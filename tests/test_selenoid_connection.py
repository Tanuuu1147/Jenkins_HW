import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.firefox.options import Options as FirefoxOptions


def test_selenoid_chrome_connection():
    """Тест подключения к Selenoid с Chrome"""
    options = ChromeOptions()
    options.set_capability('browserName', 'chrome')
    
    # Подключаемся к Selenoid
    driver = webdriver.Remote(
        command_executor='http://localhost:4444/wd/hub',
        options=options
    )
    
    try:
        # Открываем простую страницу
        driver.get("https://www.google.com")
        assert "Google" in driver.title
    finally:
        driver.quit()


def test_selenoid_firefox_connection():
    """Тест подключения к Selenoid с Firefox"""
    options = FirefoxOptions()
    options.set_capability('browserName', 'firefox')
    
    # Подключаемся к Selenoid
    driver = webdriver.Remote(
        command_executor='http://localhost:4444/wd/hub',
        options=options
    )
    
    try:
        # Открываем простую страницу
        driver.get("https://www.google.com")
        assert "Google" in driver.title
    finally:
        driver.quit()