import XCTest
@testable import Powerup

class ResultViewControllerTests: XCTestCase {
    
    var resultViewController: ResultsViewController!
    
    // Mock data source for tests (score saving & fetching).
    class MockSource: DataSource {
        
        var score: Score
        
        init(score: Score) {
            self.score = score
        }
        
        override func getScore() -> Score {
            return score
        }
        
        override func saveScore(score: Score) {
            self.score = score
        }
    }
    
    override func setUp() {
        resultViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Results View Controller") as! ResultsViewController
        resultViewController.loadView()
        
        super.setUp()
    }
    
    override func tearDown() {
        resultViewController = nil
        
        super.tearDown()
    }
    
    /**
     - Test that ResultViewController correctly saved and fetched the score
     */
    func testScoreFetchingAndSaving() {
        let originalScore = Score(karmaPoints: 31, healing: 30, strength: 20, telepathy: 10, invisibility: 40)
        
        // Given
        let mockSource = MockSource(score: originalScore)
        resultViewController.dataSource = mockSource
        
        // When
        resultViewController.gainKarmaPoints()
        
        // Then (score is correctly fetched saved, and showed.)
        let showedScore = resultViewController.karmaPointsLabel.text
        
        // Score not nil.
        XCTAssertNotNil(showedScore)
        
        // Score is correct.
        XCTAssertEqual(Int(showedScore!), originalScore.karmaPoints + resultViewController.karmaGain)
    }
    
    /**
     - Test that the labels for completed scenario and karma points are accurate
     */
    func testLabelsHaveCorrectContent() {
        let score = Score(karmaPoints: 10, healing: 10, strength: 10, telepathy: 10, invisibility: 10)
        
        // Given
        let mockSource = MockSource(score: score)
        resultViewController.dataSource = mockSource
        resultViewController.completedScenarioName = "School"
        
        // When
        resultViewController.viewDidLoad()
        
        // Then
        XCTAssertEqual(resultViewController.scenarioName.text, "Current Scenario: " + resultViewController.completedScenarioName)
        XCTAssertEqual(resultViewController.karmaPointsLabel.text, String(score.karmaPoints))
    }
    
    /**
     - Test that completing a scenario adds 20 karma points to the database.
     */
    func testGainKarmaPoints() {
        let score = Score(karmaPoints: 0, healing: 15, strength: 20, telepathy: 10, invisibility: 20)
        
        // Given
        let mockSource = MockSource(score: score)
        resultViewController.dataSource = mockSource
        
        // When
        resultViewController.gainKarmaPoints()
        
        // Then
        XCTAssertEqual(resultViewController.karmaPointsLabel.text, String(20))
    }
}
