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
        runner.addCases('iter', false);
        Report.create(runner, SuccessResultsDisplayMode.NeverShowSuccessResults, HeaderDisplayMode.AlwaysShowHeader);
        runner.run();
    }
}