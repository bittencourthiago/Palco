import Foundation

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() {
        self.val = 0; self.next = nil
    }
    public init(_ val: Int) {
        self.val = val; self.next = nil
    }
    public init(_ val: Int, _ next: ListNode?) {
        self.val = val; self.next = next
    }
    
    func printList() {
        var current: ListNode? = self
        var result = ""
        
        // Percorre a lista até o final
        while let node = current {
            result += "\(node.val)"
            if node.next != nil {
                result += " -> "
            }
            current = node.next
        }
        
        print(result)
    }
}
 
final class Solution {
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        let firstLinkedListValue = NSDecimalNumber(
            string: inverseString(performInListNodeConcating(listNode: l1))
        )

        print(firstLinkedListValue)
        let secondLinkedListValue = NSDecimalNumber(
            string: inverseString(performInListNodeConcating(listNode: l2))
        )
        
        let inverseValueOfLinkedListResult = firstLinkedListValue
            .adding(secondLinkedListValue)
        let valueOfLinkedListResult = inverseDecimal(inverseValueOfLinkedListResult)
        return splitIntoListNodes(valueOfLinkedListResult)
    }

    func splitIntoListNodes(_ number: String) -> ListNode {
        let everyDigitOnValue: [Int] = number.compactMap { item in
            item.wholeNumberValue
        }
        var firstListNode = ListNode(
            Int(inverseInt(everyDigitOnValue[0])) ?? 0,
            createNodeBasedOnDigits(
                everyDigitOnValue: everyDigitOnValue,
                currentIndex: 1
            )
        )

        return firstListNode
    }

    func createNodeBasedOnDigits(everyDigitOnValue: [Int], currentIndex: Int) -> ListNode? {
        if !everyDigitOnValue.indices.contains(Array<Int64>.Index(currentIndex)) {
            return nil
        }
        return ListNode(
            Int(inverseInt(everyDigitOnValue[currentIndex])) ?? 0,
            createNodeBasedOnDigits(
                everyDigitOnValue: everyDigitOnValue,
                currentIndex: currentIndex + 1
            )
        )
    }

    func performInListNodeConcating(listNode: ListNode?) -> String {
        if listNode?.next == nil {
            return listNode?.val.description ?? ""
        } else {
            return concat(
                val1: NSDecimalNumber(value: listNode?.val ?? 0),
                val2: performInListNodeConcating(listNode: listNode?.next)
            )
        }
    }

    func concat(val1: NSDecimalNumber, val2: String) -> String {
        "\(val1)\(val2)"
    }

    func inverseString(_ number: String) -> String {
        String(String(number).reversed())
    }
    
    func inverseInt(_ number: Int) -> String {
        String(number.description.reversed())
    }
    
    func inverseDecimal(_ number: NSDecimalNumber) -> String {
        String(number.description.reversed())
    }
}

func createLinkedList(from array: [Int]) -> ListNode? {
    guard !array.isEmpty else { return nil }
    
    let head = ListNode(array[0])
    var currentNode = head
    
    for value in array.dropFirst() {
        let newNode = ListNode(value)
        currentNode.next = newNode
        currentNode = newNode
    }
    
    return head
}

// Dados fornecidos
let l1Values = [2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 9]
let l2Values = [5, 6, 4, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 2, 4, 3, 9, 9, 9, 9]

// Criar as listas ligadas
let l1 = createLinkedList(from: l1Values)
let l2 = createLinkedList(from: l2Values)

let solution = Solution().addTwoNumbers(
    l1, l2
)

solution?.printList()


//l1 =
//[1,0,9]
//l2 =
//[5,7,8]
