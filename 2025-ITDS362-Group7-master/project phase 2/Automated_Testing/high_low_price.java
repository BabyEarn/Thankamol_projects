//import org.openqa.selenium.*;
//import org.openqa.selenium.chrome.ChromeDriver;
//import org.openqa.selenium.chrome.ChromeOptions;
//import org.openqa.selenium.support.ui.ExpectedConditions;
//import org.openqa.selenium.support.ui.WebDriverWait;
//
//import java.time.Duration;
//
//public class high_low_price {
//    public static void main(String[] args) {
//        // 1. ตั้งค่า ChromeDriver
//        ChromeOptions chromeOptions = new ChromeOptions();
//        chromeOptions.addArguments("--remote-allow-origins=*");
//        WebDriver driver = new ChromeDriver(chromeOptions);
//
//        try {
//            // 2. เปิดเว็บ
//            driver.get("http://10.34.112.158:8000/dk/store");
//
//            // 3. รอให้ปุ่ม price_desc ปรากฏและคลิกได้
//            WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
//            WebElement highLowBtn = wait.until(
//                    ExpectedConditions.elementToBeClickable(By.id("price_desc"))
//            );
//
//            // 4. scroll ให้เห็นปุ่ม (ป้องกันปุ่มอยู่ด้านล่าง/hidden)
//            ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", highLowBtn);
//
//            // 5. คลิกปุ่ม
//            try {
//                highLowBtn.click(); // คลิกปกติ
//            } catch (ElementClickInterceptedException e) {
//                // ถ้าปุ่มถูก overlay หรือ click ธรรมดาไม่ทำงาน ใช้ JS click
//                ((JavascriptExecutor) driver).executeScript("arguments[0].click();", highLowBtn);
//            }
//
//            // 6. รอผลหลัง sort (optional)
//            Thread.sleep(2000); // รอ 2 วิ ให้หน้าโหลดสินค้าใหม่
//
//            // 7. ตรวจสอบ
//            System.out.println("Page title after change high to low: " + driver.getTitle());
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        } finally {
//        }
//    }
//}

import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;

public class high_low_price {
    public static void main(String[] args) {
        ChromeOptions chromeOptions = new ChromeOptions();
        chromeOptions.addArguments("--remote-allow-origins=*");
        WebDriver driver = new ChromeDriver(chromeOptions);

        driver.get("http://10.34.112.158:8000/dk/store");

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        WebElement highLowBtn = wait.until(ExpectedConditions.elementToBeClickable(By.id("price_desc")));

        // scroll ให้เห็นปุ่ม
        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", highLowBtn);

        highLowBtn.click();

        System.out.println("Page title after change high to low: " + driver.getTitle());
    }
}