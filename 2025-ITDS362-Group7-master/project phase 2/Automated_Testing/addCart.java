import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

public class addCart {
    public static void main(String[] args) {
        ChromeOptions chromeOptions = new ChromeOptions();
        chromeOptions.addArguments("--remote-allow-origins=*");
        WebDriver driver = new ChromeDriver(chromeOptions);

        driver.get("http://10.34.112.158:8000/dk/products/test-product-handle5");

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        WebElement addBtn = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector(".transition-fg.inline-flex")));

        // scroll ให้เห็นปุ่ม
        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView(true);", addBtn);

        addBtn.click();

        System.out.println("Page title after add to cart: " + driver.getTitle());
    }
}
