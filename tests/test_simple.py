import pytest
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

def test_simple_browser():
    """Простой тест для проверки работы браузера"""
    service = Service(ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service)
    
    try:
        driver.get("https://demo.opencart.com")
        assert "OpenCart" in driver.title
    finally:
        driver.quit()