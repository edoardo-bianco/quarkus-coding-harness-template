Set-StrictMode -Version Latest

function Get-SonarObjectProperty {
    param(
        [AllowNull()][object]$InputObject,
        [Parameter(Mandatory)][string]$Name
    )

    if ($null -eq $InputObject) {
        return $null
    }
    $property = $InputObject.PSObject.Properties[$Name]
    if ($null -eq $property) {
        return $null
    }
    return $property.Value
}

function Get-SonarToken {
    $token = [Environment]::GetEnvironmentVariable("SONAR_TOKEN", "Process")
    if ([string]::IsNullOrWhiteSpace($token)) {
        throw "SONAR_TOKEN ausente no ambiente do processo. Inicie a sessão pelo launcher seguro."
    }
    return $token
}

function Assert-SonarUrl {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Url,
        [string]$ParameterName = "SonarUrl"
    )

    if ([string]::IsNullOrWhiteSpace($Url)) {
        throw "$ParameterName não pode ser vazia."
    }

    $parsed = $null
    if (-not [uri]::TryCreate($Url, [UriKind]::Absolute, [ref]$parsed) -or
        $parsed.Scheme -notin @("http", "https")) {
        throw "$ParameterName deve ser uma URL HTTP(S) absoluta."
    }
    if (-not [string]::IsNullOrEmpty($parsed.UserInfo)) {
        throw "$ParameterName não pode conter usuário ou senha."
    }
    if (-not [string]::IsNullOrEmpty($parsed.Query) -or
        -not [string]::IsNullOrEmpty($parsed.Fragment)) {
        throw "$ParameterName não pode conter query ou fragmento."
    }
    if ($parsed.AbsolutePath -match "[%\\]" -or $parsed.AbsolutePath -match "//") {
        throw "$ParameterName contém caminho não permitido."
    }

    return $parsed
}

function New-SonarApiUri {
    param(
        [Parameter(Mandatory)][uri]$BaseUri,
        [Parameter(Mandatory)][ValidatePattern("^/api/[a-z0-9_/-]+$")][string]$Endpoint,
        [Parameter(Mandatory)][System.Collections.IDictionary]$Query
    )

    $basePath = $BaseUri.AbsolutePath.TrimEnd("/")
    $uriText = $BaseUri.GetLeftPart([UriPartial]::Authority) + $basePath + $Endpoint
    $encodedPairs = @(
        foreach ($entry in $Query.GetEnumerator()) {
            if ($null -eq $entry.Value) {
                throw "Parâmetro de API SonarQube sem valor: $($entry.Key)."
            }
            $key = [uri]::EscapeDataString([string]$entry.Key)
            $value = [uri]::EscapeDataString([string]$entry.Value)
            "$key=$value"
        }
    )
    if ($encodedPairs.Count -eq 0) {
        return [uri]$uriText
    }
    return [uri]($uriText + "?" + ($encodedPairs -join "&"))
}

function Invoke-SonarApi {
    param(
        [Parameter(Mandatory)][uri]$BaseUri,
        [Parameter(Mandatory)][string]$Endpoint,
        [Parameter(Mandatory)][System.Collections.IDictionary]$Query,
        [Parameter(Mandatory)][string]$Token
    )

    $requestUri = New-SonarApiUri -BaseUri $BaseUri -Endpoint $Endpoint -Query $Query
    $headers = @{ Authorization = "Bearer $Token" }
    try {
        return Invoke-RestMethod `
            -Method Get `
            -Uri $requestUri `
            -Headers $headers `
            -TimeoutSec 30
    }
    catch {
        throw "Falha ao consultar o endpoint SonarQube $Endpoint."
    }
}

function ConvertTo-SonarMetric {
    param(
        [AllowNull()][object]$Value,
        [Parameter(Mandatory)][string]$MetricName
    )

    if ($null -eq $Value -or $Value -is [bool]) {
        throw "Métrica SonarQube inválida: $MetricName."
    }

    $parsed = 0.0
    if ($Value -is [byte] -or $Value -is [sbyte] -or
        $Value -is [int16] -or $Value -is [uint16] -or
        $Value -is [int32] -or $Value -is [uint32] -or
        $Value -is [int64] -or $Value -is [uint64] -or
        $Value -is [single] -or $Value -is [double] -or $Value -is [decimal]) {
        $parsed = [Convert]::ToDouble($Value, [Globalization.CultureInfo]::InvariantCulture)
    }
    else {
        $metricText = [string]$Value
        $valid = [double]::TryParse(
            $metricText,
            [Globalization.NumberStyles]::Float,
            [Globalization.CultureInfo]::InvariantCulture,
            [ref]$parsed
        )
        if (-not $valid) {
            throw "Métrica SonarQube inválida: $MetricName."
        }
    }
    if ([double]::IsNaN($parsed) -or [double]::IsInfinity($parsed) -or $parsed -lt 0) {
        throw "Métrica SonarQube inválida: $MetricName."
    }
    return $parsed
}

function Get-SonarIssueKey {
    param([Parameter(Mandatory)][object]$Issue)

    $key = [string](Get-SonarObjectProperty -InputObject $Issue -Name "key")
    if ([string]::IsNullOrWhiteSpace($key)) {
        throw "Issue SonarQube sem chave."
    }
    return $key
}

function Assert-SonarSnapshot {
    param(
        [Parameter(Mandatory)][object]$Snapshot,
        [Parameter(Mandatory)][string]$SnapshotName
    )

    $issuesProperty = $Snapshot.PSObject.Properties["issues"]
    if ($null -eq $issuesProperty) {
        throw "Snapshot $SnapshotName sem issues."
    }
    $issues = @($issuesProperty.Value)
    $issueCountValue = Get-SonarObjectProperty -InputObject $Snapshot -Name "issueCount"
    $issueCount = 0
    if ($null -eq $issueCountValue -or
        -not [int]::TryParse([string]$issueCountValue, [ref]$issueCount) -or
        $issueCount -ne $issues.Count) {
        throw "Snapshot $SnapshotName com issueCount inconsistente."
    }

    $keys = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    foreach ($issue in $issues) {
        $key = Get-SonarIssueKey -Issue $issue
        if (-not $keys.Add($key)) {
            throw "Snapshot $SnapshotName contém issue duplicada: $key."
        }
    }

    $metrics = Get-SonarObjectProperty -InputObject $Snapshot -Name "metrics"
    if ($null -eq $metrics) {
        throw "Snapshot $SnapshotName sem métricas."
    }
    $coverage = ConvertTo-SonarMetric `
        -Value (Get-SonarObjectProperty -InputObject $metrics -Name "coverage") `
        -MetricName "coverage"
    $duplication = ConvertTo-SonarMetric `
        -Value (Get-SonarObjectProperty -InputObject $metrics -Name "duplicatedLinesDensity") `
        -MetricName "duplicated_lines_density"

    return [pscustomobject]@{
        Issues = $issues
        Keys = $keys
        Coverage = $coverage
        Duplication = $duplication
    }
}

function Test-SonarIssueIsBlocking {
    param([Parameter(Mandatory)][object]$Issue)

    $blockingSeverities = @("HIGH", "BLOCKER", "CRITICAL")
    $legacySeverity = [string](Get-SonarObjectProperty -InputObject $Issue -Name "severity")
    if ($blockingSeverities -contains $legacySeverity.ToUpperInvariant()) {
        return $true
    }

    $impactsValue = Get-SonarObjectProperty -InputObject $Issue -Name "impacts"
    foreach ($impact in @($impactsValue)) {
        if ($null -eq $impact) {
            continue
        }
        $impactSeverity = [string](Get-SonarObjectProperty -InputObject $impact -Name "severity")
        if ($blockingSeverities -contains $impactSeverity.ToUpperInvariant()) {
            return $true
        }
    }
    return $false
}

function Compare-SonarQualitySnapshot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object]$Baseline,
        [Parameter(Mandatory)][object]$Current,
        [ValidateRange(0, 100)][double]$MinimumCoverage = 85,
        [ValidateRange(0, 100)][double]$MaximumDuplication = 5
    )

    $baselineData = Assert-SonarSnapshot -Snapshot $Baseline -SnapshotName "baseline"
    $currentData = Assert-SonarSnapshot -Snapshot $Current -SnapshotName "atual"
    $newIssueKeys = @(
        foreach ($issue in $currentData.Issues) {
            $key = Get-SonarIssueKey -Issue $issue
            if (-not $baselineData.Keys.Contains($key)) {
                $key
            }
        }
    )
    $blockingIssueKeys = @(
        foreach ($issue in $currentData.Issues) {
            if (Test-SonarIssueIsBlocking -Issue $issue) {
                Get-SonarIssueKey -Issue $issue
            }
        }
    )

    $violations = [Collections.Generic.List[object]]::new()
    if ($newIssueKeys.Count -gt 0) {
        $violations.Add([pscustomobject]@{
            Code = "NEW_ISSUES"
            Message = "$($newIssueKeys.Count) issue(s) nova(s)."
        })
    }
    if ($blockingIssueKeys.Count -gt 0) {
        $violations.Add([pscustomobject]@{
            Code = "HIGH_OR_BLOCKER"
            Message = "$($blockingIssueKeys.Count) issue(s) com severidade bloqueante."
        })
    }
    if ($currentData.Coverage -lt $MinimumCoverage) {
        $violations.Add([pscustomobject]@{
            Code = "COVERAGE"
            Message = "Cobertura abaixo de $MinimumCoverage%."
        })
    }
    if ($currentData.Duplication -gt $MaximumDuplication) {
        $violations.Add([pscustomobject]@{
            Code = "DUPLICATION"
            Message = "Duplicação acima de $MaximumDuplication%."
        })
    }

    return [pscustomobject]@{
        Passed = $violations.Count -eq 0
        Violations = @($violations)
        NewIssueKeys = @($newIssueKeys)
        HighOrBlockerIssueKeys = @($blockingIssueKeys)
        Coverage = $currentData.Coverage
        DuplicatedLinesDensity = $currentData.Duplication
    }
}

function Get-SonarQualitySnapshot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$SonarUrl,
        [Parameter(Mandatory)][ValidateLength(1, 400)][string]$ProjectKey
    )

    if ([string]::IsNullOrWhiteSpace($ProjectKey) -or $ProjectKey -match "[\r\n]") {
        throw "ProjectKey inválida."
    }
    $token = Get-SonarToken
    $baseUri = Assert-SonarUrl -Url $SonarUrl

    $analysesResponse = Invoke-SonarApi `
        -BaseUri $baseUri `
        -Endpoint "/api/project_analyses/search" `
        -Query ([ordered]@{ project = $ProjectKey; p = 1; ps = 1 }) `
        -Token $token
    $analyses = @(Get-SonarObjectProperty -InputObject $analysesResponse -Name "analyses")
    if ($analyses.Count -ne 1 -or $null -eq $analyses[0]) {
        throw "Resposta SonarQube sem análise atual."
    }
    $analysisKey = [string](Get-SonarObjectProperty -InputObject $analyses[0] -Name "key")
    if ([string]::IsNullOrWhiteSpace($analysisKey)) {
        throw "Resposta SonarQube sem chave da análise atual."
    }
    $revision = Get-SonarObjectProperty -InputObject $analyses[0] -Name "revision"

    $measuresResponse = Invoke-SonarApi `
        -BaseUri $baseUri `
        -Endpoint "/api/measures/component" `
        -Query ([ordered]@{
            component = $ProjectKey
            metricKeys = "coverage,duplicated_lines_density"
        }) `
        -Token $token
    $component = Get-SonarObjectProperty -InputObject $measuresResponse -Name "component"
    $measureValues = @{}
    foreach ($measure in @(Get-SonarObjectProperty -InputObject $component -Name "measures")) {
        if ($null -eq $measure) {
            continue
        }
        $metric = [string](Get-SonarObjectProperty -InputObject $measure -Name "metric")
        if ($metric -in @("coverage", "duplicated_lines_density")) {
            if ($measureValues.ContainsKey($metric)) {
                throw "Resposta SonarQube com métrica duplicada: $metric."
            }
            $measureValues[$metric] = Get-SonarObjectProperty -InputObject $measure -Name "value"
        }
    }
    foreach ($requiredMetric in @("coverage", "duplicated_lines_density")) {
        if (-not $measureValues.ContainsKey($requiredMetric)) {
            throw "Resposta SonarQube sem métrica obrigatória: $requiredMetric."
        }
    }
    $coverage = ConvertTo-SonarMetric -Value $measureValues.coverage -MetricName "coverage"
    $duplication = ConvertTo-SonarMetric `
        -Value $measureValues.duplicated_lines_density `
        -MetricName "duplicated_lines_density"

    $pageSize = 500
    $page = 1
    $expectedTotal = $null
    $issues = [Collections.Generic.List[object]]::new()
    $issueKeys = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
    do {
        $issuesResponse = Invoke-SonarApi `
            -BaseUri $baseUri `
            -Endpoint "/api/issues/search" `
            -Query ([ordered]@{
                componentKeys = $ProjectKey
                resolved = "false"
                p = $page
                ps = $pageSize
            }) `
            -Token $token
        $paging = Get-SonarObjectProperty -InputObject $issuesResponse -Name "paging"
        $pageIndexValue = Get-SonarObjectProperty -InputObject $paging -Name "pageIndex"
        $responsePageSizeValue = Get-SonarObjectProperty -InputObject $paging -Name "pageSize"
        $totalValue = Get-SonarObjectProperty -InputObject $paging -Name "total"
        $pageIndex = 0
        $responsePageSize = 0
        $total = 0
        if ($null -eq $paging -or
            -not [int]::TryParse([string]$pageIndexValue, [ref]$pageIndex) -or
            -not [int]::TryParse([string]$responsePageSizeValue, [ref]$responsePageSize) -or
            -not [int]::TryParse([string]$totalValue, [ref]$total) -or
            $pageIndex -ne $page -or $responsePageSize -ne $pageSize -or
            $total -lt 0 -or $total -gt 1000000) {
            throw "Resposta SonarQube com paginação inválida."
        }
        if ($null -eq $expectedTotal) {
            $expectedTotal = $total
        }
        elseif ($total -ne $expectedTotal) {
            throw "Resposta SonarQube com paginação instável."
        }

        $pageIssues = @(Get-SonarObjectProperty -InputObject $issuesResponse -Name "issues")
        $remaining = $expectedTotal - $issues.Count
        $expectedPageCount = [Math]::Min($pageSize, $remaining)
        if ($pageIssues.Count -ne $expectedPageCount) {
            throw "Resposta SonarQube com paginação truncada."
        }
        foreach ($issue in $pageIssues) {
            if ($null -eq $issue) {
                throw "Resposta SonarQube com issue nula."
            }
            $issueKey = Get-SonarIssueKey -Issue $issue
            if (-not $issueKeys.Add($issueKey)) {
                throw "Resposta SonarQube com issue duplicada entre páginas: $issueKey."
            }
            $issues.Add($issue)
        }
        $page++
    } while ($issues.Count -lt $expectedTotal)

    return [pscustomobject]@{
        capturedAtUtc = [DateTime]::UtcNow.ToString("O", [Globalization.CultureInfo]::InvariantCulture)
        analysisKey = $analysisKey
        revision = $revision
        issueCount = $issues.Count
        issues = @($issues)
        metrics = [pscustomobject]@{
            coverage = $coverage
            duplicatedLinesDensity = $duplication
        }
    }
}

function Assert-SonarComputeEngineTaskUrl {
    param(
        [Parameter(Mandatory)][uri]$BaseUri,
        [Parameter(Mandatory)][string]$TaskUrl
    )

    $taskUri = $null
    if (-not [uri]::TryCreate($TaskUrl, [UriKind]::Absolute, [ref]$taskUri) -or
        $taskUri.Scheme -notin @("http", "https") -or
        -not [string]::IsNullOrEmpty($taskUri.UserInfo) -or
        -not [string]::IsNullOrEmpty($taskUri.Fragment)) {
        throw "URL da tarefa do Compute Engine inválida."
    }
    if (-not $taskUri.Scheme.Equals($BaseUri.Scheme, [StringComparison]::OrdinalIgnoreCase) -or
        -not $taskUri.Host.Equals($BaseUri.Host, [StringComparison]::OrdinalIgnoreCase) -or
        $taskUri.Port -ne $BaseUri.Port) {
        throw "URL da tarefa do Compute Engine fora da origem SonarQube."
    }

    $expectedPath = $BaseUri.AbsolutePath.TrimEnd("/") + "/api/ce/task"
    if (-not $taskUri.AbsolutePath.Equals($expectedPath, [StringComparison]::Ordinal)) {
        throw "URL da tarefa do Compute Engine fora do endpoint esperado."
    }
    if ($taskUri.Query -notmatch "^\?id=([^&=]+)$") {
        throw "URL da tarefa do Compute Engine sem identificador exclusivo."
    }
    $taskId = [uri]::UnescapeDataString($Matches[1])
    if ([string]::IsNullOrWhiteSpace($taskId) -or $taskId -match "[\r\n]") {
        throw "Identificador da tarefa do Compute Engine inválido."
    }
    return $taskId
}

function Wait-SonarComputeEngine {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$SonarUrl,
        [Parameter(Mandatory)][string]$TaskUrl,
        [ValidateRange(1, 3600)][int]$TimeoutSec = 300,
        [ValidateRange(0, 60000)][int]$PollIntervalMilliseconds = 2000
    )

    $token = Get-SonarToken
    $baseUri = Assert-SonarUrl -Url $SonarUrl
    $taskId = Assert-SonarComputeEngineTaskUrl -BaseUri $baseUri -TaskUrl $TaskUrl
    $stopwatch = [Diagnostics.Stopwatch]::StartNew()

    while ($true) {
        $response = Invoke-SonarApi `
            -BaseUri $baseUri `
            -Endpoint "/api/ce/task" `
            -Query ([ordered]@{ id = $taskId }) `
            -Token $token
        $task = Get-SonarObjectProperty -InputObject $response -Name "task"
        $responseTaskId = [string](Get-SonarObjectProperty -InputObject $task -Name "id")
        $status = [string](Get-SonarObjectProperty -InputObject $task -Name "status")
        if ($null -eq $task -or $responseTaskId -ne $taskId -or
            [string]::IsNullOrWhiteSpace($status)) {
            throw "Resposta inválida do Compute Engine."
        }

        $normalizedStatus = $status.ToUpperInvariant()
        if ($normalizedStatus -eq "SUCCESS") {
            return $task
        }
        if ($normalizedStatus -in @("FAILED", "CANCELED")) {
            throw "Tarefa do Compute Engine terminou com status $normalizedStatus."
        }
        if ($normalizedStatus -notin @("PENDING", "IN_PROGRESS")) {
            throw "Status desconhecido do Compute Engine: $normalizedStatus."
        }
        if ($stopwatch.Elapsed.TotalSeconds -ge $TimeoutSec) {
            throw "Timeout ao aguardar a tarefa do Compute Engine."
        }
        Start-Sleep -Milliseconds $PollIntervalMilliseconds
    }
}

Export-ModuleMember -Function @(
    "Assert-SonarUrl",
    "Compare-SonarQualitySnapshot",
    "Get-SonarQualitySnapshot",
    "Wait-SonarComputeEngine"
)
