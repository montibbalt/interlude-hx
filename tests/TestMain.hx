package;

import utest.ui.common.HeaderDisplayMode;
import utest.ui.Report;
import utest.Runner;

class TestMain {
    static function main() {
        runTests();
    }

    static function runTests() {
        var runner = new Runner();
        runner.addCases('ds');
        runner.addCases('iter');
        runner.addCases('reactive');
        Report.create(runner, SuccessResultsDisplayMode.NeverShowSuccessResults, HeaderDisplayMode.AlwaysShowHeader);
        runner.run();
    }
}