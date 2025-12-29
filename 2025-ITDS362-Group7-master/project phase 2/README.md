# System Testing (Integration Test) – Medusa Store  
กลุ่ม 7 – ITDS362 Project Assignment 2

เอกสารนี้สรุป System Testing ทั้งหมด 3 Test Scenarios ที่ทำจากระบบ Medusa Store  
โดยอ้างอิงข้อมูลจากไฟล์ *System_Testing_Group7.pdf*:contentReference[oaicite:1]{index=1}

การทดสอบทั้งหมดเป็น Manual Integration Test ครอบคลุม flow ระหว่าง  
Admin → Customer → Order Creation ตาม requirement ของอาจารย์

---

# 1. Test Overview

System test นี้ออกแบบให้ครอบคลุมกระบวนการสำคัญ:

### ฝั่ง Admin
- Product and Catalog Management  
- Promotions / Discounts  
- Customer Management  
- Shipping & Region Settings  
- Order Management  

### ฝั่ง Customer
- Product Browsing & Discovery  
- Shopping Cart  
- Checkout & Payment  
- Order History  

---

# 2. Test Cases Included (3 Scenarios)

## ST-01 / TC-01 – Admin เพิ่มสินค้า + Promotion + ลูกค้าซื้อสินค้าพร้อมโค้ดส่วนลดถูกต้อง

Objective:  
ทดสอบ end-to-end ว่า Admin เพิ่มสินค้า ตั้งค่าการจัดส่ง ตั้งค่า Promotion แล้วลูกค้าซื้อสินค้าพร้อมใช้โค้ดส่วนลดได้สำเร็จ

รายละเอียดสำคัญจากไฟล์ ST-01:contentReference[oaicite:2]{index=2}  
- Admin Login สำเร็จ  
- เพิ่มสินค้า ST01-Test Product, ราคา 1000, stock = 10  
- สร้าง Region Thailand + Shipping Standard (50 บาท)  
- สร้าง Customer ใหม่ ST01 Customer  
- สร้าง Discount Code: ST01DISC10 (ลด 10%)  
- ลูกค้าใส่สินค้า 2 ชิ้น → Subtotal = 2000  
- ใช้โค้ดส่วนลด → ลด 200 → Net = 1800  
- ที่อยู่เป็น Thailand → ค่าส่ง 50  
- Grand Total = 1850 บาท  
- Order เก็บข้อมูลครบทั้งฝั่งลูกค้าและ Admin

Result: PASS ทุกขั้นตอน

---

## ST-02 / TC-02 – ทดสอบสั่งซื้อด้วยที่อยู่นอกพื้นที่จัดส่ง แล้วแก้ที่อยู่ให้ถูกต้อง

Objective:  
ตรวจสอบว่าเมื่อที่อยู่ไม่อยู่ในพื้นที่จัดส่ง (Out-of-region) ระบบจะไม่อนุญาตให้สั่งซื้อ และเมื่อแก้ไขให้เป็นพื้นที่ที่รองรับแล้วจะสามารถสั่งซื้อได้

รายละเอียดจาก Test Case ST-02:contentReference[oaicite:3]{index=3}  
- ใช้ Thailand เป็น Region ที่รองรับ  
- ใช้ Japan เป็นพื้นที่ที่สั่งไม่ได้  
- ลูกค้ามี Address = Japan  
- ไปหน้า Checkout → ไม่มี Shipping option และปุ่ม Place Order ถูก disable  
- เปลี่ยน Country → Thailand  
- Shipping Option ปรากฏทันที (Standard – 50 บาท)  
- สามารถ Place Order ได้สำเร็จ  
- Order เก็บข้อมูล Address ถูกต้อง

Result: PASS (ระบบทำงานเหมือน Out-of-region จริง)

---

## ST-03 / TC-03 – ทดสอบ Promotion 3 กรณี (โค้ดผิด / ยอดไม่ถึงขั้นต่ำ / ใช้ได้ตามเงื่อนไข)

Objective:  
ทดสอบความถูกต้องของ Discount Rules ทั้ง 3 ประเภท

รายละเอียดจาก Test Case ST-03:contentReference[oaicite:4]{index=4}  
มีสินค้า:  
- Product A = 1000  
- Product B = 800  
- Promotion: ST03DISC20 (ลด 20%), ขั้นต่ำ ≥ 2000

Flow:  
1. ใส่โค้ดผิด → แจ้งเตือน “โค้ดไม่ถูกต้อง”  
2. เพิ่มสินค้าให้ยอดรวม = 1800 → ใส่โค้ด → แจ้งเตือน “ยอดขั้นต่ำต้องถึง 2000 บาท”  
3. เพิ่ม Product A อีกชิ้น → Subtotal = 2800  
4. ใส่โค้ดถูกต้อง → ลด 560 บาท (20% ของ 2800) → Net = 2240  
5. สามารถสั่งซื้อสำเร็จ

Result: PASS (กฎส่วนลดทำงานถูกต้องครบทุกกรณี)

---

# 3. Summary of Findings

- ระบบประมวลผลตาม Business Logic ถูกต้อง  
- การเพิ่มสินค้า / ส่วนลด / ค่าจัดส่ง / ที่อยู่จัดส่ง ทำงานสอดคล้องกัน  
- ระบบป้องกันกรณีผิดปกติได้ดี (โค้ดผิด, ยอดไม่ถึงขั้นต่ำ, ที่อยู่ไม่รองรับ)  
- ไม่มี Error ระหว่างการทดสอบ ทั้งหมดผ่านทุกขั้นตอน

---

# 4. Conclusion

System Testing ของกลุ่ม 7 ครอบคลุม 3 ฟังก์ชันหลักตามข้อกำหนดของอาจารย์ ได้แก่

- การสร้างสินค้าและส่วนลด  
- การจัดส่งตาม Region  
- การใช้โค้ดส่วนลดในหลายเงื่อนไข  

ผลลัพธ์ทั้งหมดผ่านครบทุกขั้นตอน  
แสดงให้เห็นว่าระบบ Medusa Store ทำงานถูกต้องในระดับ Integration

---

# 5. Automated UI Testing (Selenium WebDriver)

ส่วนนี้เป็นการทดสอบอัตโนมัติด้วย Selenium WebDriver ตามข้อกำหนดของ Assignment โดยกลุ่มได้พัฒนาทั้งหมด **3 Test Case หลัก** และบันทึกผลลัพธ์ไว้ในโฟลเดอร์ `UI testing/`.

## 5.1 เครื่องมือที่ใช้
- Java  
- Selenium WebDriver  
- Maven  
- ChromeDriver (Chrome for Testing)  
- IntelliJ IDEA / VS Code  

---

## 5.2 Automated Test Cases

### 1) Admin_Login.java  
- เปิดหน้า Admin Login  
- กรอก email/password  
- คลิก Sign in  
- ตรวจสอบว่าเข้าสู่หน้า Dashboard ได้สำเร็จ  

Result: ผ่าน

---

### 2) addCart.java  
- เปิดหน้า product page  
- Scroll ลงหา “Add to cart”  
- คลิกปุ่ม Add to cart  
- ตรวจสอบว่ามีสินค้าใน Cart  

Result: ผ่าน

---

### 3) cartPage.java  
- เริ่มจาก Add to cart  
- คลิกปุ่ม Cart ด้านขวาบน  
- ตรวจสอบว่าเข้าสู่หน้า `/dk/cart`  

Result: ผ่าน

(หมายเหตุ: มี high_low_price.java เป็นเคสเสริมสำหรับทดสอบการ sort สินค้า)

---

## 5.3 วิธีรัน Selenium Test

รันผ่าน IDE:

- เปิดไฟล์ Java  
- คลิกปุ่ม Run ที่ `main()` ของแต่ละไฟล์  

หรือรันผ่าน Maven: mvn clean install


ผลลัพธ์จะมีทั้ง Console log และ Screenshot ในโฟลเดอร์

---

## 5.4 ผลการทดสอบ (Screenshots)

กลุ่มได้จัดเก็บผลลัพธ์ภาพจาก Selenium เช่น:

- `Admin_Login02.png`
- <img width="1286" height="980" alt="Admin_Login02" src="https://github.com/user-attachments/assets/b87f41d7-d867-4e20-acca-f5d8a0fcf670" />
- `addCart test.png`  
- <img width="1286" height="981" alt="image" src="https://github.com/user-attachments/assets/df73a896-ee26-43df-af3a-31d16980ee7c" />
- `cartPage test.png`
- <img width="1287" height="986" alt="cartPage test" src="https://github.com/user-attachments/assets/f6186d3b-bd29-49fc-9085-c2f800bb40d6" />  
ซึ่งแสดงให้เห็นว่า Selenium สามารถควบคุม browser และดำเนินการทดสอบได้ครบทุกขั้นตอนตาม test case

---

# 6. Presentation Slide (Canva)

ลิงก์สำหรับสไลด์สรุปผล System Testing:

https://www.canva.com/design/DAG5xigshlY/QjIInZaWo8-_MvD6aiLo7Q/edit?utm_content=DAG5xigshlY&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton

---
