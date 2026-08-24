package template.harness.architecture;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;
import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.Test;

import com.tngtech.archunit.core.domain.JavaClasses;
import com.tngtech.archunit.core.importer.ClassFileImporter;
import com.tngtech.archunit.core.importer.ImportOption.DoNotIncludeTests;
import com.tngtech.archunit.lang.ArchRule;

import template.harness.sample.adapter.in.rest.NormalizeTextRequest;
import template.harness.sample.application.fixture.ApplicationAdapterDependencyViolation;
import template.harness.sample.domain.fixture.DomainAdapterDependencyViolation;

class LayerDependencyTest {

    private static final String ROOT_PACKAGE = "template.harness";

    private static final ArchRule DOMAIN_DEPENDENCIES_POINT_INWARD = noClasses()
            .that().resideInAPackage("..domain..")
            .should().dependOnClassesThat()
            .resideInAnyPackage("..application..", "..adapter..");

    private static final ArchRule APPLICATION_DEPENDENCIES_POINT_INWARD = noClasses()
            .that().resideInAPackage("..application..")
            .should().dependOnClassesThat()
            .resideInAPackage("..adapter..");

    private static final JavaClasses PRODUCTION_CLASSES = new ClassFileImporter()
            .withImportOption(new DoNotIncludeTests())
            .importPackages(ROOT_PACKAGE);

    @Test
    void productionCodeRespectsLayerDirection() {
        DOMAIN_DEPENDENCIES_POINT_INWARD.check(PRODUCTION_CLASSES);
        APPLICATION_DEPENDENCIES_POINT_INWARD.check(PRODUCTION_CLASSES);
    }

    @Test
    void domainRuleDetectsAdapterDependency() {
        var classes = new ClassFileImporter().importClasses(
                DomainAdapterDependencyViolation.class,
                NormalizeTextRequest.class);

        assertThrows(AssertionError.class,
                () -> DOMAIN_DEPENDENCIES_POINT_INWARD.check(classes));
    }

    @Test
    void applicationRuleDetectsAdapterDependency() {
        var classes = new ClassFileImporter().importClasses(
                ApplicationAdapterDependencyViolation.class,
                NormalizeTextRequest.class);

        assertThrows(AssertionError.class,
                () -> APPLICATION_DEPENDENCIES_POINT_INWARD.check(classes));
    }

    @Test
    void frameworkDependenciesAreNotBlacklistedOutsideForbiddenDirections() {
        var classes = new ClassFileImporter().importClasses(
                ApplicationAdapterDependencyViolation.QuarkusUsageAllowed.class);

        assertDoesNotThrow(() -> APPLICATION_DEPENDENCIES_POINT_INWARD.check(classes));
    }
}
