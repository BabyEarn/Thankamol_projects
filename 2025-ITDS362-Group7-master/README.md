# 2025-ITDS362-Group7

## Unit test case
### Evaluate_ECC_S01Test.java
Test suite for method evaluate() of the Expression class in the exp4j library.
Technique: Each-Choice Coverage (ECC)

**Purpose:**
เพื่อทดสอบความถูกต้องของการคำนวณนิพจน์ (expression) ภายใต้รูปแบบที่หลากหลาย
โดยครอบคลุมกลุ่มข้อมูลที่เป็น valid และ invalid expressions

**Test Scenarios:**
1. No variables
2. With parentheses
3. With variable
4. Division-by-zero → Exception

#### Test Case 1 Simple expression without variables or parentheses
* Characteristics: interface-based
* Purpose: ทดสอบลำดับความสำคัญของตัวดำเนินการ (operator precedence)

```java
@Test
    public void simple_noVars_intLike() {
        double v = new ExpressionBuilder("1+2*3").build().evaluate();
        assertEquals(7.0, v, 1e-9);
    }
```

1. Identify testable functions
* simple_noVars_intLike()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.
  
3. Model the input domain
* Develop characteristics:
  * C1 = Expression contains only numbers, no variables.
  * C2 = Expression contains only arithmetic operators.
* Partition characteristics:
  
| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|

* Identify (possible) values:
  
| Characteristic | b1       | b2       |
|----------------|----------|----------|
| C1             | 1+2*3   | 1+2*a   |
| C2             | 1+2*3   | 1+2&a   |

4. Combine partitions to define test requirements (ECC)
* Test requirements — number of tests (upper bound) = 2
    * (True, True), (False, False)

5. Derive test values
**Test Cases:**
* T1 (True, True):
  * test values : 1+2*3
  * expected values: 7.0

* T2 (False, False):
  * test values: 1+2&a
  * expected values: Exception (invalid input)

 
#### Test Case 2 Expression with parentheses
* Characteristics: interface-based
* Purpose: ทดสอบการจัดลำดับการคำนวณเมื่อมีวงเล็บ (parentheses)

```java
@Test
    public void paren_noVars_intLike() {
        double v = new ExpressionBuilder("(1+2)*3").build().evaluate();
        assertEquals(9.0, v, 1e-9);
    }
```

1. Identify testable functions
* paren_noVars_intLike()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.

3. Model the input domain  
* Develop characteristics:
  * C1 = Expression contains only numbers, no variables
  * C2 = expression does contain parentheses

* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|


* Identify (possible) values:

| Characteristic | b1       | b2       |
|----------------|----------|----------|
| C1             | 1+2*3   | 1+2*a   |
| C2             | (1+2)*3   | 1+2*3   |

4. Combine partitions to define test requirements (ECC)
* Test requirements — number of tests (upper bound) = 2
    * (True, True), (False, False)

5. Derive test values
** Test Cases: **
* T1 (True, True):
  * test values : (1+2)*3
  * expected values: 9.0

* T2 (False, False):
  * test values: 1+2*a
  * expected values: Exception (invalid input)


#### Test Case 3 Expression with variable of type double
* Characteristics: functionality-based
* Purpose: ทดสอบความถูกต้องของการกำหนดและแทนค่าตัวแปรใน Expression

```java
@Test
    public void simple_oneVar_double() {
        double v = new ExpressionBuilder("x+2.5").variable("x").build()
                     .setVariable("x", 1.5).evaluate();
        assertEquals(4.0, v, 1e-9);
    }
```
1. Identify testable functions
* simple_oneVar_double()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.

3. Model the input domain
* Develop characteristics:
  * C1 = Variable state
  * C2 = Invalid syntax

* Partition characteristics:

| Characteristic | b1                 | b2                  | b3          |
|----------------|------------------|-------------------|------------|
| C1             | Declared and set  | Declared but not set | Not declared |
| C2             | True              | False             | -          |

* Identify (possible) values:

| Characteristic | b1       | b2      | b3  |
|----------------|---------|---------|-----|
| C1             | x = 3.5 | x =     | null |
| C2             | x */= 3.5 | x = 1.5 | -  |

4. Combine partitions to define test requirements (ECC)
* Test requirements — number of tests (upper bound) = 3
  * (C1b1, C2b1), (C1b1, C2b2), (C1b2, C2b1)
  * Redundant/infeasible combinations eliminated

5. Derive test values
** Test Cases: **
* T1 — (C1b1, C2b1):
  * test values : x *= 2.5
  * expected values: Exception (invalid input)
* T2 — (C1b1, C2b2):
  * test values : x = 3.5
  * expected values: 6.0
* T3 — (C1b2, C2b1):
  * test values : x =*
  * expected values: Exception (invalid input)

#### Test Case 4a Division by zero (1/0) (ECC)
* Characteristics: functionality-based
* Purpose: ทดสอบเมื่อหารด้วยศูนย์ (1/0)

```java
@Test
    public void division_semantics_infAndNaN() {
        assertTrue(Double.isInfinite(new ExpressionBuilder("1/0").build().evaluate()));
        assertTrue(Double.isNaN(new ExpressionBuilder("0/0").build().evaluate()));
    }
```

1. Identify testable functions
* division_byZero_infinite_throws()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: ArithmeticException
* Exceptional behavior: Throws ArithmeticException when dividing by zero

3. Model the input domain
* Develop characteristics:
  * C1 = Input state type

* Partition characteristics:

| Characteristic | b1      | b2       | b3     |
|----------------|---------|----------|--------|
| C1             | numeric | alphabet | syntax |

* Identify (possible) values:

| Characteristic | b1  | b2 | b3     |
|----------------|-----|----|--------|
| C1             | 5   | m  | 1+3    |

4. Combine partitions to define test requirements (ECC)
* Test requirements — number of tests (upper bound) = 3
  * numeric, alphabet, syntax
  * Redundant/infeasible combinations eliminated

5. Derive test values
** Test Cases: **
* T1 — numeric
  * test value: 5
  * expected output: throw ArithmeticException
    
* T2 — alphabet
  * test value: y
  * expected output: throw ArithmeticException
    
* T3 — syntax
  * test value: 1 + 2
  * expected output: throw ArithmeticException

#### Test Case 4b Division by zero (1/0) (ECC)
* Characteristics: functionality-based
* Purpose: ทดสอบเมื่อค่าที่คำนวณไม่สามารถนิยามได้

```java
@Test
    public void division_semantics_infAndNaN() {
        assertTrue(Double.isInfinite(new ExpressionBuilder("1/0").build().evaluate()));
        assertTrue(Double.isNaN(new ExpressionBuilder("0/0").build().evaluate()));
    }
```

1. Identify testable functions
* division_byZero_nan_throws()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: double
* Return value: ArithmeticException
* Exceptional behavior: Throws ArithmeticException when expression is invalid

3. Model the input domain
* Develop characteristics:
  * C1 = Divide by 0
  * C2 = Invalid expression

* Partition characteristics:

| Characteristic | b1   | b2    |
|----------------|------|-------|
| C1             | True | False |
| C2             | True | False |

* Identify (possible) values:

| Characteristic | b1    | b2    |
|----------------|-------|-------|
| C1             | 1/0   | 4/2   |
| C2             | 2 +/3 | 2 + 3 |

4. Combine partitions to define test requirements (ECC)
* Test requirements — number of tests (upper bound) = 2
  * (True, True), (False, False)
  * Redundant/infeasible combinations eliminated

5. Derive test values

**Test Cases:**
* T1 — (True, True)
  * test value: 6/0+
  * expected output: throw ArithmeticException
* T2 — (False, False)
  * test value: 2 + 3
  * expected output: 5.0

### SetVariable_ECC_S02Test.java
Test suite for method setVariable() and evaluate() of the Expression class in the exp4j library. 
Technique: Each-Choice Coverage (ECC)

**Purpose:**
เพื่อทดสอบการทำงานของเมธอด setVariable() ในการกำหนดค่าตัวแปร และตรวจสอบว่าการ evaluate() สามารถประมวลผลได้ถูกต้องภายใต้กรณีที่มีการกำหนดค่าและไม่กำหนดค่าให้ตัวแปร

**Test Scenarios:**
1. ตั้งค่าตัวแปร (set variable) แล้ว evaluate ได้ผลลัพธ์ที่เปลี่ยนไปตามค่าใหม่
2. ไม่ได้ตั้งค่าตัวแปร (missing variable) แล้ว evaluate ควรโยนข้อยกเว้น IllegalArgumentException
   
#### Test Case 1: set variable 'x' to different values before evaluation
* Characteristics: functionality-based
* Purpose: ทดสอบการเปลี่ยนค่า (assignment) ตัวแปร และผลกระทบต่อ evaluate()

```java
@Test
    public void set_thenEvaluate_changesValue() {
        Expression e = new ExpressionBuilder("x+1").variable("x").build();
        assertEquals(3.0, e.setVariable("x", 2).evaluate(), 1e-9);
        assertEquals(6.0, e.setVariable("x", 5).evaluate(), 1e-9);
    }
```

1. Identify testable functions
* set_thenEvaluate_changesValue()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: e, the result of the evaluated arithmetic expression
* Exceptional behavior: Throws exception if value assigned is invalid

3. Model the input domain
* Develop characteristics:
  * C1 = Alphabet or special syntax instead of number

* Partition characteristics:

| Characteristic | b1       | b2          | b3     |
|----------------|----------|-------------|--------|
| C1             | alphabet | special syntax | number |

* Identify (possible) values:

| Characteristic | b1 | b2     | b3  |
|----------------|----|--------|-----|
| C1             | r  | 7k+1   | 8   |

4. Combine partitions to define test requirements (ECC)
* Test requirements — number of tests (upper bound) = 3
  * (C1b1), (C1b2), (C1b3)
  * Redundant/infeasible combinations eliminated

5. Derive test values

**Test Cases:**
* T1 — (C1b1)
  * test value: q
  * expected output: Exception (invalid input)
* T2 — (C1b2)
  * test value: 10j+p
  * expected output: Exception (invalid input)
* T3 — (C1b3)
  * test value: 14
  * expected output: 15

#### Test Case 2 Evaluate expression without setting variable 'x'
* Characteristics: interface-based
* Purpose: ทดสอบการจัดการข้อผิดพลาดกรณี evaluate() ถูกเรียกโดยยังไม่ได้กำหนดค่าตัวแปรที่จำเป็น

```java
@Test
    public void missingVariable_thenEvaluate_throws() {
        Expression e = new ExpressionBuilder("x+1").variable("x").build();
        try {
            e.evaluate();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
        }
    }
 ```
   
1. Identify testable functions
* missingVariable_thenEvaluate_throws()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.
* Exceptional behavior: Throws IllegalArgumentException

4. Model the input domain  
* Develop characteristics:
    * C1 = Variables is empty.
    * C2 = Expression contains only arithmetic operators.

* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|


* Identify (possible) values:

| Characteristic | b1       | b2       |
|----------------|----------|----------|
| C1             | x=Invalid |  x=2  |
| C2             | x+1   |  x$1  |

4. Combine partitions to define test requirements (ECC)
* Test requirements — number of tests (upper bound) = 2
    * (True, False), (False, True)

5. Derive test values
**Test Cases:**
* T1 (True, False):
    * test values: x$1 ไม่ได้กำหนดค่า x
    * expected values: Throws IllegalArgumentException 

* T2 (False, True):
    * test values : x+1 กำหนด x=2 
    * expected values: 3.0

### SetVariables_PWC_S03Test.java
Test suite for methods setVariables() and evaluate() of the Expression class in the exp4j library.
Technique: Pairwise Coverage (PWC)

**Purpose:**
เพื่อทดสอบการทำงานของเมธอด setVariables() ที่สามารถกำหนดค่าตัวแปรหลายตัวพร้อมกัน โดยออกแบบชุดทดสอบแบบ Pairwise Coverage เพื่อครอบคลุมการจับคู่ค่าของตัวแปร x และ y ในกรณีปกติ กรณีขาดค่าบางตัว และกรณีค่าติดลบหรือศูนย์

**Test Scenarios:**
1. กำหนดค่าทุกตัวแปรครบ (All variables provided)
2. ขาดค่าตัวแปรบางตัว (Missing variable)
3. ค่าตัวแปรเป็นศูนย์และค่าติดลบ (Zero and negative values)

#### Test case 1: All variables provided (x=2, y=3)
* Characteristics: functionality-based
* Purpose: ทดสอบการคำนวณเมื่อกำหนดค่าตัวแปรครบทั้งสองตัว

```java
@Test
    public void allProvided_twoVars() {
        Expression e = new ExpressionBuilder("x*y + x").variables("x","y").build();
        double v = e.setVariables(Map.of("x", 2.0, "y", 3.0)).evaluate();
        assertEquals(8.0, v, 1e-9);
    }
```
1. Identify testable functions
* allProvided_twoVars()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: v, the result of the evaluated arithmetic expression

3. Model the input domain
* Develop characteristics:
  * C1 = x is not alphabet or special syntax instead of number
  * C2 = y is not alphabet or special syntax instead of number

* Partition characteristics:

| Characteristic | b1      | b2       | b3         |
|----------------|---------|----------|------------|
| C1             | number  | alphabet | special syntax |
| C2             | number  | alphabet | special syntax |

* Identify (possible) values:

| Characteristic | b1  | b2    | b3   |
|----------------|-----|-------|------|
| C1             | 6   | c     | 2+   |
| C2             | 12  | w     | 3..4 |

4. Combine partitions to define test requirements (PWC)
* Test requirements — number of tests (upper bound) = 3*3 = 9
  * ((C1,b1),(C2,b1)), ((C1,b2),(C2,b2)), ((C1,b3),(C2,b3))
  * ((C1,b1),(C2,b2)), ((C1,b2),(C2,b3)), ((C1,b3),(C2,b1))
  * ((C1,b1),(C2,b3)), ((C1,b2),(C2,b1)), ((C1,b3),(C2,b2))
  * Redundant/infeasible combinations eliminated

5. Derive test values

**Test Cases:**
* T1 — ((C1,b1),(C2,b1))
  * test value: 2, 3
  * expected output: 8.0
* T2 — ((C1,b2),(C2,b2))
  * test value: p, q
  * expected output: Exception (invalid input)
* T3 — ((C1,b3),(C2,b3))
  * test value: 5z, 1*/
  * expected output: Exception (invalid input)
* T4 — ((C1,b1),(C2,b2))
  * test value: 15, k
  * expected output: Exception (invalid input)
* T5 — ((C1,b2),(C2,b3))
  * test value: j, 5//
  * expected output: Exception (invalid input)
* T6 — ((C1,b3),(C2,b1))
  * test value: ..6, 7
  * expected output: Exception (invalid input)
* T7 — ((C1,b1),(C2,b3))
  * test value: 2, 3*-
  * expected output: Exception (invalid input)
* T8 — ((C1,b2),(C2,b1))
  * test value: m, 9
  * expected output: Exception (invalid input)
* T9 — ((C1,b3),(C2,b2))
  * test value: 1*/, q
  * expected output: Exception (invalid input)

#### Test Case 2 Missing one variable (only x provided)
* Characteristics: interface-based
* Purpose: ทดสอบการจัดการข้อผิดพลาดเมื่อขาดค่าตัวแปรบางตัวใน pair (x,y)

```java
@Test
    public void missingOneVar_throws() {
        Expression e = new ExpressionBuilder("x+y").variables("x","y").build();
        try {
            e.setVariables(Map.of("x", 1.0)).evaluate();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
            // ok
        }
    }
```

1. Identify testable functions
* missingOneVar_throws()
  
2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: Map<String, Double>
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.
* Exceptional behavior: Throws IllegalArgumentException
  
3. Model the input domain  
Develop characteristics:
C1 = Variable 1 is empty
C2 = Variable 2 is empty

* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|

* Identify (possible) values:

| Characteristic | b1       | b2       |
|----------------|----------|----------|
| C1             | x=Invalid |  x=1.0  |
| C2             | y=Invalid |  y=2.0  |

4. Combine partitions to define test requirements (PWC)
* Test requirements — number of tests (upper bound) = 2x2 = 4
    * (True, True), (False, False),
        (True, False), (False, True)

5. Derive test values
**Test Cases:**
* T1 (True, True):
    * test values : x+y ไม่ได้กำหนดค่าของ x และ y
    * expected values: Throws IllegalArgumentException 


* T2 (False, False):
    * test values: x+y กำหนด x=1.0, y=2.0
    * expected values: 3.0


* T3 (True, False):
    * test values : x+y กำหนด x ไม่ได้กำหนดค่า และ y = 2.0
    * expected values: Throws IllegalArgumentException


* T4 (False, True):
    * test values : x+y กำหนด x=1.0, และ y ไม่ได้กำหนดค่า
    * expected values:  Throws IllegalArgumentException

#### Test Case 3 Variables with zero and negative values (x=0, y=-2)
* Purpose: ทดสอบการคำนวณของนิพจน์เมื่อมีค่าศูนย์และค่าติดลบในตัวแปร (pairwise edge case)
* Characteristics: interface-based

```java
@Test
    public void missingOneVar_throws() {
        Expression e = new ExpressionBuilder("x+y").variables("x","y").build();
        try {
            e.setVariables(Map.of("x", 1.0)).evaluate();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
            // ok
        }
    }
```
  
1. Identify testable functions
* zeroAndNegativeValues()
  
2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: Map<String, Double>
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.
  
3. Model the input domain  
* Develop characteristics:
    * C1 = Variables is zero
    * C2 = Variables is negative

* Partition characteristics:

| Characteristic | b1   | b2   | b3   |
|----------------|------|------|------|
| C1             | <0   | 0    | >0   |
| C2             | <0   | >=0  | -    |


* Identify (possible) values:

| Characteristic | b1    | b2   | b3   |
|----------------|-------|------|------|
| C1             | x=-1  | x=0  | y=1  |
| C2             | y=-2  | y=0  | -    |


4. Combine partitions to define test requirements (PWC)
* Test requirements — number of tests (upper bound) = 3x2 = 6
    * (<0, <0), (<0, >=0),
    (0, <0), (0, >=0),
    (>0, <0), (>0, >=0)
  
5. Derive test values
**Test Cases:**
* T1 (<0, <0):
    * test values : x-y กำหนด x=-1, y=-2
    * expected values: 1.0


* T2 (<0, >=0):
    * test values:  x-y กำหนด x=-1, y=0
    * expected values:  -1.0


* T3 (0, <0):
    * test values : x-y กำหนด x=0, y=-2
    * expected values: 2.0


* T4 (0, >=0):
    * test values : x-y กำหนด x=0, y=2 
    * expected values: -2.0


* T5 (>0, <0):
    * test values : x-y กำหนด x=1, y=-2
    * expected values: 3.0


* T6 (>0, >=0):
    * test values : x-y กำหนด x=1, y=2
    * expected values: 3.0

### Variable_Method_BCC_S04Test.java
Test suite for methods variable(), setVariable(), and evaluate() of the Expression class in the exp4j library.
Technique: Base Choice Coverage (BCC)

**Purpose:**
เพื่อทดสอบการทำงานของการประกาศและกำหนดค่าตัวแปรในนิพจน์ (expression) โดยใช้แนวคิด Base Choice Coverage — เลือกกรณีฐาน (base case) และสร้างกรณีเพิ่มเติม โดยเปลี่ยนเงื่อนไขเพียงหนึ่งปัจจัยต่อครั้ง เพื่อให้ครอบคลุมพฤติกรรมหลักของระบบ

**Test Scenarios:**
1. Base case: ไม่มีตัวแปรในนิพจน์ (no variable)
2. เปลี่ยนจาก base case → เพิ่มตัวแปรและกำหนดค่า (declare and set variable)
3. เปลี่ยนจาก base case → เพิ่มตัวแปรแต่ไม่กำหนดค่า (declare without setting)

#### Test Case 1 (Base Case) Expression without any variables
* Characteristics: interface-based
* Purpose: ใช้เป็นกรณีฐาน (base case) เพื่อเปรียบเทียบกับกรณีที่มีตัวแปรในนิพจน์

```java
@Test
    public void base_noVar_ok() {
        double v = new ExpressionBuilder("1+2*3").build().evaluate();
        assertEquals(7.0, v, 1e-9);
    }
```

1. Identify testable functions
* base_noVar_ok()
  
2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.

3. Model the input domain
* Develop characteristics:
    * C1 = Expression contains only numbers, no variables
    * C2 = Expression contains only arithmetic operators

* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|

* Identify (possible) values:

| Characteristic | b1       | b2       |
|----------------|----------|----------|
| C1             | 1+2*3   | 1+2*a   |
| C2             | 1+2*3   | 1+2&3   |

4. Combine partitions to define test requirements (BCC)
* Test requirements — number of tests (upper bound) = 1+((2-1)+(2-1)) = 3
        **Base test: (True, True)**
      * (True, False), (False, True)

5. Derive test values
**Test Cases:**
* T1 (True, True):
    * test values : 1+2*3
    * expected values: 7.0

* T2 (True, False):
    * test values: 1+2&3
    * expected values: Exception (invalid input)

* T3 (False, True):
    * test values : 1+2*a
    * expected values: Exception (invalid input)

#### Test Case 2 Declare variable 'x' and assign value before evaluation
* Characteristics: functionality-based
* Purpose: ทดสอบการเพิ่มตัวแปรจาก base case และกำหนดค่าก่อน evaluate()

```java
@Test
    public void declareVar_thenSet_ok() {
        Expression e = new ExpressionBuilder("x+2").variable("x").build();
        assertEquals(5.0, e.setVariable("x", 3).evaluate(), 1e-9);
    }
```

1. Identify testable functions
* declareVar_thenSet_ok()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: double
* Return value: `e`, the result of the evaluated arithmetic expression
* Exceptional behavior: Throws exception if syntax is invalid or variable not set

3. Model the input domain
* Develop characteristics:
  * C1 = Invalid syntax
  * C2 = Variable state

* Partition characteristics:

| Characteristic | b1    | b2               | b3          |
|----------------|-------|-----------------|------------|
| C1             | True  | False           | -          |
| C2             | Declared and set | Declared but not set | Not declared |

* Identify (possible) values:

| Characteristic | b1      | b2  | b3   |
|----------------|---------|-----|------|
| C1             | x -* 6  | x=2 | -    |
| C2             | x=13    | x=  | null |

4. Combine partitions to define test requirements (BCC)
* Test requirements — number of tests (upper bound) = 4
  * Base choice: (C1b2, C2b1)
  * ((C1b2,C2b1)), ((C1b2,C2b3)), ((C1b1,C2b1)), ((C1b2,C2b2))
  * Redundant/infeasible combinations eliminated

5. Derive test values

**Test Cases:**
* T1 — (C1b2, C2b1)
  * test value: x = 3
  * expected output: 5.0
* T2 — (C1b2, C2b3)
  * test value: 
  * expected output: Exception (invalid input)
* T3 — (C1b1, C2b1)
  * test value: x = *9
  * expected output: Exception (invalid input)
* T4 — (C1b2, C2b2)
  * test value: x =
  * expected output: Exception (invalid input)

#### Test Case 3 Declare variable 'x' but do not assign any value
* Characteristics: interface-based
* Purpose: ทดสอบการเปลี่ยนปัจจัยจาก base case โดยเพิ่มตัวแปรแต่ไม่กำหนดค่า (คาดว่า evaluate จะล้มเหลว)

```java
@Test
    public void declareVar_butNotSet_throws() {
        Expression e = new ExpressionBuilder("x+2").variable("x").build();
        try {
            e.evaluate();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
            // ok
        }
    }
```

1. Identify testable functions
* declareVar_butNotSet_throws()

3. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.
* Exceptional behavior: Throws IllegalArgumentException

5. Model the input domain  
* Develop characteristics:
    * C1 = Variables is empty
    * C2 = Expression is not contains arithmetic operators

* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|

* Identify (possible) values:

| Characteristic | b1       | b2       |
|----------------|----------|----------|
| C1             | x=Invalid   | x=2  |
| C2             | x$2   | x+2   |

4. Combine partitions to define test requirements (BCC)
* Test requirements — number of tests (upper bound) = 1+((2-1)+(2-1)) = 3
    **Base test: (True, True)**
    * (True, False), (False, True)

5. Derive test values
**Test Cases:**
* T1 (True, True):
    * test values: x$2 ไม่ได้กำหนดค่า x
    * expected values:  Throws IllegalArgumentException 

* T2 (True, False):
    * test values : x+2 ไม่ได้กำหนดค่า x 
    * expected values: Throws IllegalArgumentException

* T3 (False, True):
    * test values: x$2 กำหนด x=2
    * expected values:  Throws IllegalArgumentException

### S05_Variables_Method_ACoC_Test
Test suite for methods variables(), setVariables(), and evaluate() of the Expression class in the exp4j library.
Technique: All-Combinations Coverage (ACoC)

**Purpose:**
เพื่อทดสอบการทำงานของเมธอด setVariables() และ evaluate() เมื่อมีตัวแปรหลายตัวในนิพจน์
โดยใช้เทคนิค All-Combinations Coverage (ACoC) เพื่อครอบคลุมการผสมค่าของตัวแปรทุกแบบ รวมถึงกรณีที่มีตัวแปรครบ ขาดบางตัว และชื่อที่มีอักขระพิเศษ (_)

**Test Scenarios:**
1. ตัวแปรครบทุกตัวและมีค่าทั้งหมด (all variables provided)
2. ขาดค่าตัวแปรบางตัว (missing one variable)
3. ชื่อตัวแปรที่ขึ้นต้นด้วย underscore (_) (valid special name)

#### Test Case 1 All variables provided (a=2, b=4, c=1)
* Characteristics: functionality-based
* Purpose: ทดสอบการคำนวณเมื่อกำหนดค่าตัวแปรครบทุกตัวในนิพจน์ (full combination)

```java
@Test
    public void multipleVars_allSet_ok() {
        Expression e = new ExpressionBuilder("a*b + c").variables("a","b","c").build();
        double v = e.setVariables(Map.of("a", 2.0, "b", 4.0, "c", 1.0)).evaluate();
        assertEquals(9.0, v, 1e-9);
    }
```

1. Identify testable functions
* multipleVars_allSet_ok()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: e, the result of the evaluated arithmetic expression
* Exceptional behavior: Throws exception if variables are invalid 

3. Model the input domain
* Develop characteristics:
  * C1 = Variable state
  * C2 = Invalid syntax

* Partition characteristics:

| Characteristic | b1                 | b2                  | b3          |
|----------------|------------------|-------------------|------------|
| C1             | Declared and set  | Declared but not set | Not declared |
| C2             | True              | False             | -          |

* Identify (possible) values:

| Characteristic | b1                | b2             | b3           |
|----------------|-----------------|----------------|-------------|
| C1             | a=3, b=4, c=5   | a=, b=, c=     | null        |
| C2             | a//8, b-., c*-7 | a=1, b=4, c=7  | -           |

4. Combine partitions to define test requirements (ACoC)
* Test requirements — number of tests (upper bound) = 3*2 = 6
  * (b1, True), (b2, True), (b3, True)
  * (b1, False), (b2, False), (b3, False)
  * Redundant/infeasible combinations eliminated

5. Derive test values
**Test Cases:**
* T1 — (b1, True)
  * test value: a=8, b=3, c=4
  * expected output: 28.0
* T2 — (b2, True)
  * test value: a=, b=, c=
  * expected output: Exception (invalid input)
* T3 — (b3, True)
  * test value: null
  * expected output: Exception (invalid input)
* T4 — (b1, False)
  * test value: a=9, b&7, c)3
  * expected output: Exception (invalid input)
* T5 — (b2, False)
  * test value: a=, b*, c()
  * expected output: Exception (invalid input)
* T6 — (b3, False)
  * test value: a=8, b=null, c=null
  * expected output: Exception (invalid input)

#### Test Case 2: All variables provided 
* Characteristics: interface-based
* Purpose: ทดสอบการคำนวณเมื่อกำหนดค่าครบทุกตัวแปรในนิพจน์ (full combination)

```java
 @Test
    public void multipleVars_oneMissing_throws() {
        Expression e = new ExpressionBuilder("a+b+c").variables("a","b","c").build();
        try {
            e.setVariables(Map.of("a", 1.0, "b", 2.0)).evaluate();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
            // ok
        }
    }
```

1. Identify testable functions
* multipleVars_oneMissing_throws()

3. Identify parameters, return types, return values, and exceptional behavior
* Parameters: Map<String, Double>
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.
* Exceptional behavior: Throws IllegalArgumentException

5. Model the input domain  
* Develop characteristics:
    * C1 = Variables is empty
    * C2 = Expression is not contains arithmetic operators

* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|

* Identify (possible) values:

| Characteristic | b1       | b2       |
|----------------|----------|----------|
| C1             | c=Invalid   | c=3.0  |
| C2             | a+b$c  | a+b+c  |

4. Combine partitions to define test requirements (ACoC)
* Test requirements — number of tests (upper bound) = 2x2 = 4
    * (True, True), (False, False),
        (True, False), (False, True)

5. Derive test values
**Test Cases:**
* T1 (True, True):
    * test values: a+b$c ไม่ได้กำหนดค่า c
    * expected values:  Throws IllegalArgumentException 

* T2 (False, False):
    * test values : a+b+c กำหนด a=1.0, b=2.0, c=3.0
    * expected values: 6.0

* T3 (True, False):
    * test values: a+b+c ไม่ได้กำหนดค่า c
    * expected values:  Throws IllegalArgumentException 

* T4 (False, True):
    * test values: a+b$c กำหนด a=1.0, b=2.0, c=3.0
    * expected values:  Throws IllegalArgumentException

#### Test Case 3: Variable name with underscore (_x = 5)
* Characteristics: functionality-based
* Purpose: ทดสอบการรองรับชื่อตัวแปรที่มี underscore ซึ่งถือเป็นชื่อที่ถูกต้องตามไวยากรณ์

```java
@Test
    public void underscoreVarName_ok() {
        Expression e = new ExpressionBuilder("_x + 1").variable("_x").build();
        assertEquals(6.0, e.setVariable("_x", 5).evaluate(), 1e-9);
    }
```

1. Identify testable functions
* underscoreVarName_ok()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: double
* Return value: e, the result of the evaluated arithmetic expression
* Exceptional behavior: Throws exception if variable name is invalid syntax

3. Model the input domain
* Develop characteristics:
  * C1 = Variable name state

* Partition characteristics:

| Characteristic | b1       | b2     | b3     |
|----------------|---------|--------|--------|
| C1             | alphabet | with _ | syntax |

* Identify (possible) values:

| Characteristic | b1  | b2   | b3     |
|----------------|-----|------|--------|
| C1             | x   | _x   | +x     |

4. Combine partitions to define test requirements (ACoC)
* Test requirements — number of tests (upper bound) = 3
  * b1, b2, b3
  * Redundant/infeasible combinations eliminated

5. Derive test values
**Test Cases:**
* T1 — b1
  * test value: x = 6
  * expected output: 7.0
* T2 — b2
  * test value: _x = 1
  * expected output: 2.0
* T3 — b3
  * test value: {m = 7
  * expected output: Exception (invalid input)

### Function_Method_ACoC_S06Test.java
Test suite for custom unary function and the evaluate() method in the exp4j library.
Technique: All-Combinations Coverage (ACoC)

**Purpose:**
เพื่อทดสอบฟังก์ชันกำหนดเองแบบ unary "inc(x)" และการ evaluate() โดยครอบคลุมชุดค่าทุก combination ของปัจจัยที่เลือก ได้แก่
- ประเภท argument (ค่าคงที่ / ตัวแปร)
- ระดับการซ้อนของฟังก์ชัน (ไม่ซ้อน / ซ้อน 1 ชั้น)

**Test Scenarios:**
1. argument เป็นค่าคงที่ และไม่ซ้อนฟังก์ชัน
2. argument เป็นตัวแปร และไม่ซ้อนฟังก์ชัน
3. argument เป็นค่าคงที่ และซ้อนฟังก์ชัน 1 ชั้น

#### Test Case 1: Unary custom function with constant argument
* Characteristics: interface-based
* Purpose: ทดสอบ combination ของฟังก์ชัน inc(x)

```java
@Test
    public void unary_customFunction_const() {
        double v = new ExpressionBuilder("inc(2)").function(inc).build().evaluate();
        assertEquals(3.0, v, 1e-9);
    }
```

1. Identify testable functions
* unary_customFunction_const()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: Double
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.

3. Model the input domain  
* Develop characteristics:
    * C1 = Function name is valid.
    * C2 = A value is provided to the function.
      
* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|

* Identify (possible) values:

| Characteristic | b1       | b2       |
|----------------|----------|----------|
| C1             | inc()   | ina()  |
| C2             | inc(2) | inc()  |

4. Combine partitions to define test requirements (ACoC)
* Test requirements — number of tests (upper bound) = 2x2 = 4
    * (True, True), (False, False),
        (True, False), (False, True)

5. Derive test values
**Test Cases:**
* T1 (True, True):
    * test values: inc(2)
    * expected values:  3.0 

* T2 (False, False):
    * test values: ina() 
    * expected values:  Exception (invalid input) 

* T3 (True, False):
    * test values:  inc() 
    * expected values: Exception (invalid input)

* T4 (False, True):
    * test values:  ina(2) 
    * expected values:  Exception (invalid input)

#### Test Case 2 Unary custom function with variable argument (ACoC)
* Characteristics: functionality-based
* Purpose: ทดสอบการคำนวณของฟังก์ชัน inc(x) เมื่อ argument เป็นตัวแปร

```java
@Test
    public void unary_customFunction_var() {
        double v = new ExpressionBuilder("inc(x)").variable("x").function(inc).build()
                     .setVariable("x", 5).evaluate();
        assertEquals(6.0, v, 1e-9);
    }
```
1. Identify testable functions
* unary_customFunction_var()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: v, the result of the evaluated arithmetic expression

3. Model the input domain
* Develop characteristics:
  * C1 = Argument type 
  * C2 = Variable state 

* Partition characteristics:

| Characteristic | b1             | b2                 | b3  |
|----------------|----------------|------------------|-----|
| C1             | numeric        | alphabet          | syntax |
| C2             | declared and set | declared but not set | not declared |

* Identify (possible) values:

| Characteristic | b1   | b2   | b3   |
|----------------|------|------|------|
| C1             | 5    | x    | x*+  |
| C2             | x=5  | x=   | null |

4. Combine partitions to define test requirements (ACoC)
* Test requirements — number of tests (upper bound)  = 9 
* ((b1,b1)), ((b1,b2)), ((b1,b3)), ((b2,b1)), ((b2,b2)), ((b2,b3)), ((b3,b1)), ((b3,b2)), ((b3,b3))

5. Derive test values

**Test Cases:**
* T1 — (C1b1, C2b1)
  * test value: x=5
  * expected output: 6.0
* T2 — (C1b1, C2b2)
  * test value: x=
  * expected output: invalid
* T3 — (C1b1, C2b3)
  * test value: null
  * expected output: invalid
* T4 — (C1b2, C2b1)
  * test value: x=a
  * expected output: invalid
* T5 — (C1b2, C2b2)
  * test value: x=
  * expected output: invalid
* T6 — (C1b2, C2b3)
  * test value: null
  * expected output: invalid
* T7 — (C1b3, C2b1)
  * test value: x*+
  * expected output: invalid
* T8 — (C1b3, C2b2)
  * test value: x*+
  * expected output: invalid
* T9 — (C1b3, C2b3)
  * test value: null
  * expected output: invalid

#### Test Case 3 Nested unary custom function (ACoC)
* Characteristics: functionality-based
* Purpose: ทดสอบการคำนวณของฟังก์ชัน inc(inc(x)) เมื่อ argument เป็นค่าคงที่หรือฟังก์ชันซ้อน

```java
@Test
    public void nested_customFunction() {
        double v = new ExpressionBuilder("inc(inc(2))").function(inc).build().evaluate();
        assertEquals(4.0, v, 1e-9);
    }
```

1. Identify testable functions
* nested_customFunction()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: v, the result of the evaluated arithmetic expression

3. Model the input domain
* Develop characteristics:
  * C1 = Argument type 
  * C2 = Nesting level 

* Partition characteristics:

| Characteristic | b1      | b2      | b3  |
|----------------|---------|---------|-----|
| C1             | numeric | alphabet| syntax |
| C2             | 1       | 2       | 3   |

* Identify (possible) values:

| Characteristic | b1       | b2       | b3       |
|----------------|----------|----------|----------|
| C1             | 2        | x        | 2+       |
| C2             | 1        | 2        | 3        |

4. Combine partitions to define test requirements (ACoC)
* Test requirements — number of tests (upper bound)  = 9 
    * ((b1,b1)), ((b1,b2)), ((b1,b3)),
  ((b2,b1)), ((b2,b2)), ((b2,b3)),
  ((b3,b1)), ((b3,b2)), ((b3,b3))

5. Derive test values

**Test Cases:**
* T1 — (C1b1, C2b1)
  * test value: inc(2)
  * expected output: 3.0
* T2 — (C1b1, C2b2)
  * test value: inc(inc(2))
  * expected output: 4.0
* T3 — (C1b1, C2b3)
  * test value: inc(inc(inc(2)))
  * expected output: 5.0
* T4 — (C1b2, C2b1)
  * test value: inc(x)
  * expected output: invalid
* T5 — (C1b2, C2b2)
  * test value: inc(inc(x))
  * expected output: invalid
* T6 — (C1b2, C2b3)
  * test value: inc(inc(inc(x)))
  * expected output: invalid
* T7 — (C1b3, C2b1)
  * test value: inc(2+)
  * expected output: invalid
* T8 — (C1b3, C2b2)
  * test value: inc(inc(2+))
  * expected output: invalid
* T9 — (C1b3, C2b3)
  * test value: inc(inc(inc(2+)))
  * expected output: invalid

### Functions_Method_BCC_S07Test.java
Test suite for custom functions and the evaluate() method in the exp4j library.
Technique: All Combinations (ACoC)

**Purpose:**
เพื่อทดสอบการทำงานของการสร้างและเรียกใช้ฟังก์ชัน (Function) ภายในนิพจน์ โดยใช้แนวคิด Base Choice Coverage (BCC) ซึ่งเริ่มจากกรณีฐาน (single function)
แล้วเปลี่ยนปัจจัยเพียงหนึ่งอย่างต่อกรณีเพื่อให้ครอบคลุมพฤติกรรมที่แตกต่าง

**Test Scenarios:**
1. Base case: ฟังก์ชันเดียว (single custom function)
2. เพิ่มอีกฟังก์ชันหนึ่งและเรียกใช้งานร่วมกัน (add second function)
3. สลับลำดับการลงทะเบียนฟังก์ชัน (order of registration)

#### Test Case 1 (Base Case): Single function usage "sq(3)"
* Characteristics: interface-based
* Purpose: ใช้เป็นกรณีฐาน (base case) เพื่อตรวจสอบว่าฟังก์ชันเดียวทำงานถูกต้อง

```java
@Test
    public void base_singleFunction() {
        double v = new ExpressionBuilder("sq(3)").functions(sq).build().evaluate();
        assertEquals(9.0, v, 1e-9);
    }
```

1. Identify testable functions
* base_singleFunction

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: Double
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.

3. Model the input domain  
* Develop characteristics:
    * C1 = Function name is valid.
    * C2 = A value is provided to the function.

* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|

* Identify (possible) values:

| Characteristic | b1       | b2       |
|----------------|----------|----------|
| C1             | sq()   | sa()  |
| C2             | sq(3) | sq()  |

4. Combine partitions to define test requirements (BCC)
* Test requirements — number of tests (upper bound) =  1+((2-1)+(2-1)) = 3
        **Base test: (True, True)**
    * (True, False), (False, True)

5. Derive test values
**Test Cases:**
* T1 (True, True):
    * test values: sq(3) 
    * expected values:  9.0 

* T2 (True, False):
    * test values: sq() 
    * expected values: Exception (invalid input)

* T3 (False, True):
    * test values: sa(3) 
    * expected values:  Exception (invalid input)

#### Test Case 2: Unary custom function with constant argument
* Characteristics: functionality-based
* Purpose: ทดสอบการใช้ฟังก์ชันเดียวกับ argument เป็นค่าคงที่

```java
@Test
    public void addSecondFunction_pairUse() {
        double v = new ExpressionBuilder("sq(sum2(2,3))").functions(sq, sum2).build().evaluate();
        assertEquals(25.0, v, 1e-9);
    }
```

1. Identify testable functions
* addSecondFunction_pairUse()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: v, the result of the evaluated arithmetic expression

3. Model the input domain
* Develop characteristics:
  * C1 = Argument type
  * C2 = Function name
  * C3 = Argument count

* Partition characteristics:

| Characteristic | b1       | b2       | b3  |
|----------------|----------|----------|-----|
| C1             | numeric  | alphabet | syntax |
| C2             | True     | False    | -   |
| C3             | null     | 1        | 2   |

* Identify (possible) values:

| Characteristic | b1                  | b2                 | b3              |
|----------------|-------------------|------------------|----------------|
| C1             | sq(sum2(2, 3))    | sq(sum2(a, b))   | sq(sum2(+, /)) |
| C2             | sq(sum2(2, 3))    | sg(smal2(2, 3))  | -              |
| C3             | sq(sum())          | sq(sum(1))       | sq(sum2(2, 3)) |

4. Combine partitions to define test requirements (BCC)
* Test requirements — number of tests (upper bound) =  4
        **Base test: (C1b1, C2b1, C3b1)**
    * (C1b2, C2b1, C3b1), (C1b1, C2b2, C3b1), (C1b1, C2b1, C3b2)  

5. Derive test values

**Test Cases:**
* T1 — Base choice (C1b1, C2b1, C3b1)
  * test value: sq(sum2(2, 3))
  * expected output: 25.0
* T2 — Change C1 (C1b2, C2b1, C3b1)
  * test value: sq(sum2(a, b))
  * expected output: Exception (invalid input)
* T3 — Change C2 (C1b1, C2b2, C3b1)
  * test value: sg(smal2(2, 3))
  * expected output: Exception (invalid input)
* T4 — Change C3 (C1b1, C2b1, C3b2)
  * test value: sq(sum2(2))
  * expected output: Exception (invalid input)

#### Test Case 3: Unary custom function with constant argument — function registration order (BCC)
* Characteristics: functionality-based
* Purpose: ทดสอบว่าลำดับการลงทะเบียนฟังก์ชันไม่ส่งผลต่อผลลัพธ์การคำนวณ

```java
@Test
    public void orderOfRegistration_notAffectResult() {
        double a = new ExpressionBuilder("sq(sum2(2,3))").functions(sq, sum2).build().evaluate();
        double b = new ExpressionBuilder("sq(sum2(2,3))").functions(sum2, sq).build().evaluate();
        assertEquals(a, b, 1e-9);
    }
```

1. Identify testable functions
* orderOfRegistration_notAffectResult()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: a, b

3. Model the input domain
* Develop characteristics:
  * C1 = Function name
  * C2 = Function independence

* Partition characteristics:

| Characteristic | b1  | b2  |
|----------------|-----|-----|
| C1             | True | False |
| C2             | a = b | a != b |

* Identify (possible) values:

| Characteristic | b1              | b2                 |
|----------------|----------------|------------------|
| C1             | sq(sum(2, 3))  | squ(summ(2, 3))  |
| C2             | 25.0, 25.0     | 25.0, 10.0       |

4. Combine partitions to define test requirements (BCC)
* Test requirements — number of tests (upper bound) =  4
      **Base test: (C1b1, C2b1)**
    * (C1b1, C2b2), (C1b2, C2b1), (C1b2, C2b2)

5. Derive test values

**Test Cases:**
* T1 — Base choice (C1b1, C2b1)
  * test value: sq(sum(2, 3))
  * expected output: 25.0, 25.0
* T2 — Change C2 (C1b1, C2b2)
  * test value: sq(sum(2, 3))
  * expected output: 25.0, 10.0
* T3 — Change C1 (C1b2, C2b1)
  * test value: squ(summ(2, 3))
  * expected output: Exception (invalid input)
* T4 — Change C1 & C2 (C1b2, C2b2)
  * test value: hii(hello(2, 3))
  * expected output: Exception (invalid input)


### Operator_Method_MBCC_S08Test.java
Test suite for operator() registration and evaluate() in the exp4j library.
Technique: Multiple Base Choice Coverage (MBCC)

**Purpose:**
เพื่อทดสอบการเพิ่ม custom operator และตรวจสอบผลของ precedence ต่อการ evaluate()

**Test Scenarios:**
1. ไม่มี custom operator → ตรวจสอบผลลัพธ์พื้นฐาน
2. มี custom operator ">>" → ตรวจสอบลำดับความสำคัญ (operator precedence)

#### Test Case 1 (Base Case): Without custom operator
* Characteristics: interface-based
* Purpose: ทดสอบ evaluate() พื้นฐานเพื่อยืนยันผลการคำนวณที่ถูกต้องของ operator มาตรฐาน

```java
@Test
    public void base_withoutCustomOp() {
        double v = new ExpressionBuilder("1+2*3").build().evaluate();
        assertEquals(7.0, v, 1e-9);
    }
```

1. Identify testable functions
* base_withoutCustomOp()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.

3. Model the input domain
* Develop characteristics:
    * C1 = Expression contains only numbers, no variables.
    * C2 = Expression contains only arithmetic operators.

* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|

* Identify (possible) values:

| Characteristic | b1       | b2       |
|----------------|----------|----------|
| C1             | 1+2*3   | 1+2*a   |
| C2             | 1+2*3   | 1+2&3   |

4. Combine partitions to define test requirements (MBCC)
* Test requirements — number of tests (upper bound) = 2+(2x(2-2)+2x(2-2)) = 2
        **Base test: (True, True), (False, False)**

5. Derive test values
Test Cases:
T1 (True, True):
test values : 1+2*3
expected values: 7.0

T2 (False, False):
test values: 1+2&a
expected values: Exception (invalid input)

#### Test Case 2 With custom operator "@" (precedence lower than '*')
* Characteristics: functionality-based
* Purpose: ทดสอบผลของ operator precedence เมื่อเพิ่ม custom operator "@" ที่มีความสำคัญต่ำกว่าการคูณ

```java
 @Test
    public void withCustomOp_samePrecAsMul() {
        double v = new ExpressionBuilder("1@2*3").operator(AT_SAME_AS_MUL).build().evaluate();
        // parse as 1 @ (2*3) = 1 + 2*(6) = 13
        assertEquals(13.0, v, 1e-9);
    }
```

1. Identify testable functions
* withCustomOp_lowerPrecThanMul()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: double
* Return value: v, the result of the evaluated arithmetic expression

3. Model the input domain
* Develop characteristics:
  * C1 = Operator is true (used correctly)
  * C2 = Operator precedence

* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False |

* Identify (possible) values:

| Characteristic | b1        | b2          |
|----------------|-----------|-------------|
| C1             | 1@(3*4)  | 3*> (6-7)  |

4. Combine partitions to define test requirements (MBCC)
* Test requirements — number of tests (upper bound) = 2
  * (C1b1), (C1b2)

5. Derive test values
**Test Cases:**
* T1 — (C1b1)
  * test value: 1@(2*3)
  * expected output: 13.0
* T2 — (C1b2)
  * test value: 6*/ >> 36+a
  * expected output: Exception (invalid input)

### Operators_Method_PWC_S09Test.java
Test suite for registering multiple custom operators and evaluate() in the exp4j library.
Technique: Pairwise Coverage (PWC)

**Purpose:**
เพื่อทดสอบผลของการกำหนด custom operators มากกว่า 1 ตัว และผลของ precedence ต่อการ parse/evaluate โดยใช้ Pairwise Coverage เพื่อครอบคลุมการทำงานร่วมกันเป็นคู่ ๆ (pairwise) ระหว่างตัวดำเนินการ

**Test Scenarios:**
1) ทั้งสอง custom operators ถูกใช้งานร่วมกันใน expression เดียว (interplay)
2) สลับลำดับการลงทะเบียน operators เพื่อยืนยันว่า parsing/ผลลัพธ์ไม่เปลี่ยน(order-insensitive)

**Note:** Use "<<" and "&&" as custom operators since exp4j restricts some symbols. 
Custom operator "<<": a << b := a - 2*b
Precedence = PRECEDENCE_ADDITION - 1 (ต่ำกว่า '+') 

Custom operator "&&": a && b := a + 2*b
Precedence = PRECEDENCE_MULTIPLICATION (เท่ากับ '*') 

#### Test Case 1 Interplay of two custom operators in one expression
* Characteristics: interface-based
* Purpose: ทดสอบการทำงานร่วมกันแบบเป็นคู่ (pairwise) ของ custom operators ที่มี precedence ต่างกัน

```java
@Test
    public void bothCustomOps_interplay() {
        double v = new ExpressionBuilder("1#2@3")
                .operator(HASH_LOW, AT_MUL).build().evaluate();
        // @ first -> 2@3 = 2 + 6 = 8; then 1#8 = 1 - 16 = -15
        assertEquals(-15.0, v, 1e-9);
    }
```

1. Identify testable functions
* bothCustomOps_interplay()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.

3. Model the input domain
* Develop characteristics:
    * C1 = Left operands of the operators
    * C2 = Right operands of operators
    * C3 = Custom operators conform to the specification.

* Partition characteristics:

| Characteristic | b1   | b2   | b3   |
|----------------|------|------|------|
| C1             | <0 | 0 | >0   |
| C2             | <0 | 0 | >0   |
| C3             | True | False|  - |

* Identify (possible) values:

| Characteristic | b1   | b2   | b3   |
|----------------|------|------|------|
| C1             | -1 | 0 | 1   |
| C2             | -1 | 0 | 1   |
| C3             | #,@ | ex.<,&| -  |

4. Combine partitions to define test requirements (PWC)
* Test requirements — number of tests (upper bound) = 3x3 = 9
    * (<0, <0, True), (<0, 0, True), (<0, >0, True),
    * (0, <0, False), (0, 0, False), (0, >0, False),
    * (>0, <0, True), (>0, 0, True), (>0, >0, True)

6. Derive test values
**Test Cases:**
* T1 (<0, <0, True):
    * test values : -1#-2@-3
    * expected values: 15

* T2 (<0, 0, True):
    * test values: -1#2@0
    * expected values: -17

* T3 (<0, >0, True):
    * test values : -1#2@3
    * expected values: Exception (invalid input)

* T4 (0, <0, False):
    * test values: 0$0@-1
    * expected values: Exception (invalid input)

* T5 (>0, 0, True):
    * test values : 1#2@&0
    * expected values: Exception (invalid input)

* T6 (0, >0, False):
    * test values: 0##2@3
    * expected values: Exception (invalid input)

* T7 (>0, <0, True):
    * test values: 1#2@-3
    * expected values: 9

* T8 (>0, 0, True):
    * test values : 1#2@0
    * expected values: -3

* T9 (>0, >0, True):
    * test values: 1#2@3
    * expected values: -15

#### Test Case 2 Registration order of custom operators
* Characteristics: functionality-based
* Purpose: ทดสอบว่าลำดับ operator ไม่ส่งผลต่อผลลัพธ์

```java
 @Test
    public void registrationOrder_notAffectParsing() {
        double a = new ExpressionBuilder("1#2@3").operator(HASH_LOW, AT_MUL).build().evaluate();
        double b = new ExpressionBuilder("1#2@3").operator(AT_MUL, HASH_LOW).build().evaluate();
        assertEquals(a, b, 1e-9);
    }
```

1. Identify testable functions
* registrationOrder_notAffectParsing()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: int
* Return value: a, b

3. Model the input domain
* Develop characteristics:
  * C1 = Operator is true (used correctly)
  * C2 = Operator registration independence

* Partition characteristics:

| Characteristic | b1  | b2    |
|----------------|-----|-------|
| C1             | True | False |
| C2             | a = b | a != b |

* Identify (possible) values:

| Characteristic | b1     | b2           |
|----------------|--------|-------------|
| C1             | 1#2@3 | 1<>2&%3     |
| C2             | -15.0, -15.0 | 16.0, -15.0 |

4. Combine partitions to define test requirements (PWC)
* Test requirements — number of tests (upper bound) = 4
  * (C1b1, C2b1), (C1b2, C2b2), (C1b1, C2b2), (C1b2, C2b1)

5. Derive test values
**Test Cases:**
* T1 — (C1b1, C2b1)
  * test value: 1#2@3
  * expected output: -15.0, -15.0
* T2 — (C1b2, C2b2)
  * test value: 2><6+&9
  * expected output: invalid
* T3 — (C1b1, C2b2)
  * test value: 1#2@3
  * expected output: -15.0, -15.0
* T4 — (C1b2, C2b1)
  * test value: 2>/69^7
  * expected output: invalid

### Build_MBCC_S10Test.java
Test suite for the build() and evaluate() methods of the ExpressionBuilder class in the exp4j library.
Technique: Multiple Base Choice Coverage (MBCC)

**Purpose:**
เพื่อทดสอบกระบวนการสร้าง (build) และประเมินค่า (evaluate) นิพจน์ภายใต้หลายกรณีฐาน (multiple base cases)
โดยใช้เทคนิค MBCC ซึ่งเลือกกรณีฐานหลายแบบ (เช่น นิพจน์ถูกต้อง, ฟังก์ชันไม่รู้จัก, วงเล็บไม่สมดุล)
แล้วเปลี่ยนปัจจัยเพียงหนึ่งอย่างในแต่ละกรณีเพื่อครอบคลุมความเสี่ยงหลักของการสร้าง expression

**Test Scenarios:**
1. Valid expression → build สำเร็จ
2. Unknown function → IllegalArgumentException (ขณะ build หรือ evaluate)
3. Malformed expression → IllegalArgumentException (วงเล็บไม่สมดุล)

#### Test Case 1 (Base Case) Expression without any variables
* Characteristics: interface-based
* Purpose: ใช้เป็นกรณีฐาน (base case) เพื่อเปรียบเทียบกับกรณีที่มีตัวแปรในนิพจน์

```java
@Test
    public void validExpression_buildSucceeds() {
        try {
            new ExpressionBuilder("(1+2)*(3+4)").build();
        } catch (Exception ex) {
            fail("Should build without exceptions, but got: " + ex);
        }
    }
```

1. Identify testable functions
* validExpression_buildSucceeds()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.

3. Model the input domain
* Develop characteristics:
    * C1 = Expression contains only numbers, no variables
    * C2 = Parentheses are balanced

* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|

* Identify (possible) values:

| Characteristic | b1       | b2       |
|----------------|----------|----------|
| C1             | 1+2*3   | 1+2*a   |
| C2             | (1+2)*(3+4) | (1+2)*(3+4  |

4. Combine partitions to define test requirements (MBCC)
* Test requirements — number of tests (upper bound) = 2+(2x(2-2)+2x(2-2)) = 2
        **Base test: (True, True), (False, False)**

5. Derive test values
**Test Cases:**
* T1 (True, True):
    * test values : (1+2)*(3+4)
    * expected values: 21.0

* T2 (False, False):
    * test values: (1+2)*(3+a
    * expected values: Exception (invalid input)
      
#### Test Case 2 Unknown function on build or evaluate
* Characteristics: functionality-based
* Purpose: ทดสอบเมื่อเรียกใช้ฟังก์ชันที่ไม่รู้จัก 

```java
@Test
    public void unknownFunction_onBuildOrEval_throws() {
        try {
            Expression expr = new ExpressionBuilder("foo(2)").build(); // some versions throw here
            // if build didn't throw, evaluate should
            expr.evaluate();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
            // ok
        }
    }
```

1. Identify testable functions
* unknownFunction_onBuildOrEval_throws()

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: e, the result of the evaluated arithmetic expression
* Exceptional behavior:  throw IllegalArgumentException

3. Model the input domain
* Develop characteristics:
  * C1 = Unknown function
  * C2 = Return IllegalArgumentException

* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|

* Identify (possible) values:

| Characteristic | b1        | b2           |
|----------------|-----------|--------------|
| C1             | foo(2)    | Math.abs(-5) |
| C2             | throw IllegalArgumentException | 5 |

4. Combine partitions to define test requirements (MBCC)
* Test requirements — number of tests (upper bound) = 2
  * (C1b1, C2b1), (C1b2, C2b2)

5. Derive test values
**Test Cases:**
* T1 — (C1b1, C2b1)
  * test value: ivy(3)
  * expected output: throw IllegalArgumentException
* T2 — (C1b2, C2b2)
  * test value: Math.pow(2, 3)
  * expected output: 8.0

#### Test Case 3 Declare variable 'x' but do not assign any value
* Characteristics: interface-based
* Purpose: ทดสอบการเปลี่ยนปัจจัยจาก base case โดยตัวดำเนินการผิดพลาด (คาดว่า evaluate จะล้มเหลว)

```java
@Test
    public void malformedExpression_doublePlus_illegalArgument() {
        try {
            new ExpressionBuilder("1++2").build();
            fail("Expected IllegalArgumentException");
        } catch (IllegalArgumentException expected) {
            // ok
        }
    }
```

1. Identify testable functions
* malformedExpression_doublePlus_illegalArgument

2. Identify parameters, return types, return values, and exceptional behavior
* Parameters: String
* Return type: Double
* Return value: The result of the evaluated arithmetic expression.
* Exceptional behavior: Throws IllegalArgumentException 

3. Model the input domain
* Develop characteristics:
    * C1 = Expression contains only numbers, no variables.
    * C2 = Operators are not valid arithmetic operators.

* Partition characteristics:

| Characteristic | b1   | b2   |
|----------------|------|------|
| C1             | True | False|
| C2             | True | False|

* Identify (possible) values:

| Characteristic | b1       | b2       |
|----------------|----------|----------|
| C1             | 1+2   | 1+a   |
| C2             | 1+2| 1++2  |

4. Combine partitions to define test requirements (MBCC)
* Test requirements — number of tests (upper bound) = 2+(2x(2-2)+2x(2-2)) = 2
        **Base test: (True, True), (False, False)**

5. Derive test values
**Test Cases:**
* T1 (True, True):
    * test values: 1+2 
    * expected values:  3.0 

* T2 (False, False):
    * test values : 1++2 
    * expected values: Throws IllegalArgumentException
