import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;
import java.time.Duration;

public class Admin_Login {
    public static void main(String[] args) {

        ChromeOptions chromeOptions = new ChromeOptions();
        chromeOptions.addArguments("--remote-allow-origins=*");

        WebDriver driver = new ChromeDriver(chromeOptions);

        // URL Login
        String baseUrl = "http://10.34.112.158:9000/app/login";

        driver.get(baseUrl);

        // find email's input
        WebElement email = driver.findElement(By.name("email"));

        // find password's input
        WebElement password = driver.findElement(By.name("password"));

        // input data for login
        email.sendKeys("group7@mu-store.local");
        password.sendKeys("Tg7!yvD8");

        // click login
        WebElement signinBtn = driver.findElement(By.cssSelector("button[type='submit']"));
        signinBtn.click();

        // dashboard waiting
        new WebDriverWait(driver, Duration.ofSeconds(10))
                .until(ExpectedConditions.titleContains("Admin"));

        System.out.println("Page title after login: " + driver.getTitle());

        driver.quit();
    }
}