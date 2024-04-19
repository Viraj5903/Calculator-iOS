//
//  ViewController.swift
//  Calculator
//
//  Created by Viraj Patel and Rohan Amlani on 2024-02-02.
//

import UIKit

class Calculator {
    
    // Static method to perform calculations and manage results
    static func calculation(_ num1: Double) -> (() -> Double, (Double) -> Void , (Double) -> Void, (Double) -> Void, (Double) -> Void, (Double) -> Void) {
        
        // Initialize a variable to hold the current result
        var result = num1

        // Define closures for basic arithmetic operations
        
        // Closure to perform addition
        let add: (Double) -> Void = { num2 in
            result += num2
        }

        // Closure to perform multiplication
        let multiplication: (Double) -> Void = { num2 in
            result *= num2
        }

        // Closure to perform subtraction
        let subtraction: (Double) -> Void = { num2 in
            result -= num2
        }

        // Closure to perform division
        let division: (Double) -> Void = { num2 in
            result /= num2
        }

        // Closure to get the current result
        let getResult: () -> Double = {
            return result
        }
        
        // Closure to set a new result
        let setResult: (Double) -> Void = { x in
            result = x
        }

        // Return a tuple containing all closures
        return (getResult, setResult, add, subtraction, multiplication, division)
    }
}


class ViewController: UIViewController {

    // Labels to display the current input and result.
    @IBOutlet weak var OutputLabel: UILabel!
    @IBOutlet weak var ExpressionLabel: UILabel!
    
    // Variables to store current number, expression, and operation
    var number: String = ""           // Stores the current number input as a string
    var currentNumber: Double = 0     // Stores the current number input as a Double
    var expression: String = ""       // Stores the expression being constructed (including numbers and operators)
    var operation: ((Double) -> Void)?// Stores the operation closure to be performed on numbers
    var history: String = ""
        
    // Flags and closures for calculator operations
    // Flag that will check whether operator button is clicked or not.
    var operatorFlag: Bool = false    // Flag to track if an operator button is clicked
    var (getResult, setResult, add, subtract, multiply, divide) = Calculator.calculation(0) // Tuple containing closures for calculator operations
        
    // Clearing the variable, labels and operation to initial state.
    @IBAction func ACButton(_ sender: UIButton) {
        
        // Reset the number string to an empty string
        number = ""

        // Reset the currentNumber variable to 0
        currentNumber = 0

        // Reset the operation to nil, indicating no operation is selected
        operation = nil

        // Reset the expression string to an empty string
        expression = ""

        // Update the expression label text to display "0"
        ExpressionLabel.text = "0"

        // Update the output label text to display "0"
        OutputLabel.text = "0"

        // Call the `Calculator.calculation` function with argument 0, which returns a tuple of functions for calculator operations.
        // Assign these functions to the respective variables.
        (getResult, setResult, add, subtract, multiply, divide) = Calculator.calculation(0)

    }
    
    // Handling positive/negative button
    @IBAction func PlusMinusButton(_ sender: UIButton) {
        
        // Removing the previously entered number from the expression
        expression.removeLast(number.count)
        history.removeLast(number.count)
        
        // Checking if the current number (string) can be converted to a Int
        if var intValue = Int(number) {
            // If successful, multiplying the number by -1 to change its sign
            intValue = intValue * -1
            // Converting the updated number back to a string and assigning it to 'number'
            number = String(intValue)
            // Checking if the current number (string) can be converted to a Double
        }
        else if var numb = Double(number) {
            // If successful, multiplying the number by -1 to change its sign
            numb = numb * -1
            // Converting the updated number back to a string and assigning it to 'number'
            number = String(numb)
        } else {
            // If the conversion fails (no number entered yet), and currentNumber is not zero
            if currentNumber != 0 {
                // Toggling the sign of currentNumber
                currentNumber *= -1
            }
        }
        
        // Adding the updated number (with the sign changed if applicable) back to the expression
        expression += number
        history += number
        // Updating the expression label to reflect the changes
        ExpressionLabel.text = expression
        
    }
    
    @IBAction func NumberButtons(_ sender: UIButton) {
        
        // Check if the button label text (the digit) exists
        guard let digit = sender.titleLabel!.text else {
            // If there's no digit, there's nothing to do, so exit the function
            return
        }

        // Special case: if the digit is a decimal point and the number string is empty
        if (digit == "." && number == "") {
            // Set the number to "0" and update the expression accordingly
            number = "0"
            expression += "0"
        }
        
        // Check if the digit is a decimal point and if the number string already contains a decimal point
        if (digit == "." && number.contains(".")) {
            // If the digit is a decimal point and the number already has one, stop and don't add another
            return
        }

        // Add the clicked digit to the end of the expression and number strings
        expression += digit
        history += digit
        number += digit

//        // Convert the updated number string to a Double and assign it to currentNumber
//        currentNumber = Double(number)!

        // Update the expression label to display the updated expression
        ExpressionLabel.text = expression

    }
    
    
    @IBAction func OperationButton(_ sender: UIButton) {
        
        // Try to extract the text from the sender's (button's) title label
        guard let selectedOperation = sender.titleLabel!.text else {
            // If the text extraction fails (titleLabel text is nil), return from the function
            return
        }
        
        // Try to convert the current number string to a Double
        if let num = Double(number) {
            // If successful, set currentNumber to the converted value
            currentNumber = num
            // Reset the operatorFlag to indicate that an operator button has not been clicked yet
            operatorFlag = false
        } else {
            // If the conversion fails, check if an operation is not yet selected
            if operation == nil {
                // If no operation is selected, set the currentNumber to 0
                currentNumber = 0
                // Update the expression to reflect the addition of 0
                expression += "0"
            } else {
                // If an operation is selected, set the operatorFlag to true
                operatorFlag = true
                // Remove the last character from the expression to correct the operator sequence
                expression.removeLast()
            }
        }

        // Reset the number string to prepare for the next input
        number = ""
        // Append the selected operation to the expression
        expression += selectedOperation
        // Update the expression label to display the updated expression
        ExpressionLabel.text = expression

        // Check if an operator button was clicked previously
        guard operatorFlag == false else {
            // If an operator button was clicked, get the operation corresponding to the selected operation
            getOperation(selectedOperation)
            // Exit the function as the operation will be performed when the next number button is clicked
            return
        }

        // If a new operator button is clicked and there was a previous operation selected, then perform the previous operation with the currentNumber
        if let operation = operation {
            // Perform the previous operation with the currentNumber
            operation(currentNumber)
            // Update the output label to display the result of the operation
            OutputLabel.text = "\(getResult())"
        } else {
            // If no operation is set, update the result to the currentNumber
            setResult(currentNumber)
        }

        // Get the new operation corresponding to the selected operation
        getOperation(selectedOperation)
    }
    
    
    @IBAction func EqualOperator(_ sender: UIButton) {
    
        // Try to convert the current number string to a Double
        if let num = Double(number) {
            // If successful, set currentNumber to the converted value
            currentNumber = num
        }

        // Check if an operation is set
        if let operation_ = operation {
            // Perform the last operation with the previous result and the current input (currentNumber)
            operation_(currentNumber)
            
            // Update the output label to display the result of the operation
            OutputLabel.text = "\(getResult())"
            
            // Update the expression label to display the current expression
            ExpressionLabel.text = expression
            
            // Update the expression with the result for further calculations
            expression = "\(getResult())"
            
            // Update the number string with the result for further calculations
            number = "\(getResult())"
            
            // Reset the operation to nil as it's completed
            operation = nil
        }
    }
    
    @IBAction func rewinedOperation(_ sender: UIButton) {
        ExpressionLabel.text = history
    }
    
    // Function to assign the operation based on the selected operator
    func getOperation(_ selectedOperation: String) {
        
        // Switch statement to determine the operation based on the selectedOperator
        switch selectedOperation {
            case "+":
                // If the selected operation is addition, assign the 'add' operation
                operation = add
            case "-":
                // If the selected operation is subtraction, assign the 'subtract' operation
                operation = subtract
            case "x":
                // If the selected operation is multiplication, assign the 'multiply' operation
                operation = multiply
            case "÷":
                // If the selected operation is division, assign the 'divide' operation
                operation = divide
                // $1 == 0 ? 0 : $0/$1
            default:
                // If the selected operation is none of the above, do nothing
                break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
