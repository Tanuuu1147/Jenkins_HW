import os
from pages.category_page import CategoryPage

def test_local_catalog_page(browser):
    # Получаем абсолютный путь к локальному файлу
    file_path = os.path.abspath("tests/test_local.html")
    url = f"file://{file_path}"
    
    page = CategoryPage(browser).open(url)
    page.wait_visible(CategoryPage.BREADCRUMB)
    page.wait_visible(CategoryPage.LEFT_MENU)
    page.wait_visible(CategoryPage.SORT)
    page.wait_visible(CategoryPage.LIMIT)
    page.wait_visible(CategoryPage.PRODUCT_TILES)