package template.harness.architecture;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.Test;

import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import com.tngtech.archunit.core.importer.ImportOption.DoNotIncludeTests;
import com.tngtech.archunit.lang.ArchRule;

import template.harness.sample.adapter.in.rest.NormalizeTextRequest;
import template.harness.sample.application.fixture.ApplicationAdapterDependencyViolation;

class BoundaryContractTest {

    private static final String ROOT_PACKAGE = "template.harness";
    private static final String REST_INPUT_BOUNDARY = "..adapter.in.rest..";

    private static final ArchRule REST_CONTRACTS_STAY_INSIDE_THEIR_BOUNDARY = noClasses()
            .that().resideOutsideOfPackage(REST_INPUT_BOUNDARY)
            .should().dependOnClassesThat()
            .resideInAPackage(REST_INPUT_BOUNDARY);

    private static final JavaClasses PRODUCTION_CLASSES = new ClassFileImporter()
            .withImportOption(new DoNotIncludeTests())
            .importPackages(ROOT_PACKAGE);

    @Test
    void productionCodeKeepsRestContractsInsideInputBoundary() {
        REST_CONTRACTS_STAY_INSIDE_THEIR_BOUNDARY.check(PRODUCTION_CLASSES);
    }

    @Test
    void boundaryRuleDetectsRestContractLeak() {
        var classes = new ClassFileImporter().importClasses(
                ApplicationAdapterDependencyViolation.class,
                NormalizeTextRequest.class);

        assertThrows(AssertionError.class,
                () -> REST_CONTRACTS_STAY_INSIDE_THEIR_BOUNDARY.check(classes));
    }
}
