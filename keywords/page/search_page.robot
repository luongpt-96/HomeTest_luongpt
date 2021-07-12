*** Setting ***
Resource    ${CURDIR}/../web_resources_import.robot

*** Variables ***
${screen_size_group}    css:div[title="Screen Size Group (inches)"] * div[class='Checkbox-dODbyV kzpWEi']
${screen_size_opt}    css:div[title='{titile_name}']
${lbl_size_option}    xpath://div[contains(@class,'Padding') and text() = '{size_inch} inches']
${opt_size_option}    xpath://div[contains(@class,'Padding') and text() = '{size_inch} inches']//parent::div[contains(@class,'Col__Column')]//parent::div[contains(@class,'Row__Wrapper')]/div[1]/div[contains(@class,'Checkbox')]
${opt_number_product}    xpath://div[contains(@class,'Padding') and text() = '{size_inch} inches']/div/span
${target_product}    css:div[data-productid='{sku}']
${target_product_name}    css:div[data-productid='{sku}'] a:last-child span
${expected_product}    xpath://div[@class="ProductGridItem__Label-iQRkAY jLwkyu"]/parent::div/parent::div/parent::div/div[1]
${example_locator}    xpath://div[@class="ProductGridItem__Label-iQRkAY jLwkyu"]/parent::div/parent::div/parent::div

***Keyword***
Search products by name and specificcation
    [Arguments]    ${name}    ${specificcation}
    common_keywords.Search desired product by name    ${name}
    Select filter follow option    ${specificcation}
    BuiltIn.Sleep     5S

Select filter follow option
    [Arguments]    ${size}
    ${screen_size_filter}    String.Format String    ${screen_size_opt}    titile_name=${screen_size_title}
    ${opt_locator}    String.Format String    ${opt_size_option}    size_inch=${size}
    common_keywords.Scroll To Element    ${screen_size_filter}
    common_keywords.Click Element    ${opt_locator}

Get sku from search result
    common_keywords.Verify Web Element Is Visible    ${example_locator}
    ${list}    SeleniumLibrary.Get WebElements    ${example_locator}
    ${sku}    SeleniumLibrary.Get Element Attribute    ${list}[1]    data-productid
    [Return]    ${sku}

Click particular product with SKU
    ${sku}    Get sku from search result
    ${prd_locator}    String.Format String    ${target_product}    sku=${sku}
    ${prd_name_locator}    String.Format String    ${target_product_name}    sku=${sku}
    ${name}    common_keywords.Get Text Element    ${prd_name_locator}
    common_keywords.Scroll Down And Wait To Get Available Element    ${prd_locator}
    Sleep    2S
    common_keywords.Click Element    ${prd_name_locator}
    BuiltIn.Return From Keyword    ${name}