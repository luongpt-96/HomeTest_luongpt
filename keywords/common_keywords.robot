*** Settings ***
Resource    web_resources_import.robot

*** Variables ***
${entire_page}    xpath://body
${popup_iframe}    css:body > div.sp-fancybox-wrap.sp-fancybox-wrap-2168.sp-advanced-css-2168.adaptive-resolution.adaptive-position.adaptive-x-position-center.adaptive-y-position-middle > iframe
${search_input_box}    css:[class='MainHeader__StyledWrapper-fBqfJn igXJea'] #txt-searchBox-input
${search_button}    css:[class='MainHeader__StyledWrapper-fBqfJn igXJea'] #btn-searchBox-input
${search_result_text}    css:h1[class='Text-sc-9p67zt-0 dLudwb']    
${shopping_cart_number}    css:div [class='MiniCart__CartQty-bJioin bNCDDv'] span    
${shopping_cart_icon}    css:div[class='MainHeader__MiniCartContainer-cOzool KbPez'] a[id=btn-openMiniCart]
${prod_tag}    css:[class="Row__Wrapper-v6uxgu-0 kSLyDU"] [class="ProductBadge__Relative-bxGwEa emnXMc"]
${iframe_target}    css:div[classname="sp-fancybox-wrap sp-fancybox-wrap-2405 sp-advanced-css-2405"] iframe[classname="sp-fancybox-iframe sp-fancybox-skin sp-fancybox-iframe-2405"]
${close_popup_btn}    css:#wrap-close-button-1454703945249

${GLOBALTIMEOUT}     ${15}

*** Keywords ***

Open browser to page
    [Arguments]    ${url}    ${speed}=0.1 
    ${options}=     Evaluate     sys.modules['selenium.webdriver'].ChromeOptions()     sys
    ${exclude}=    Create Dictionary    "fasp"=True
    ${prefs}=    Create Dictionary    protocol_handler.excluded_schemes=${exclude}
    Call Method     ${options}    add_argument     --disable-infobars
    Call Method     ${options}    add_experimental_option    prefs    ${prefs}
    SeleniumLibrary.Create WebDriver     Chrome      chrome_options=${options}
    SeleniumLibrary.Maximize Browser Window
    SeleniumLibrary.Set Selenium Speed     ${speed}
    SeleniumLibrary.Go To     ${url}
Close popup
    BuiltIn.Run Keyword And Ignore Error     Switch iframe and click

Switch iframe and click
    Verify Web Element Is Visible    ${iframe_target}
    Sleep    5s
    BuiltIn.Run Keyword And Ignore Error     SeleniumLibrary.Select frame     ${iframe_target}
    BuiltIn.Run Keyword And Ignore Error     SeleniumLibrary.Select frame     ${iframe_target}
    BuiltIn.Run Keyword And Ignore Error     Click Element    ${close_popup_btn}  
    BuiltIn.Run Keyword And Ignore Error     SeleniumLibrary.Click Element At Coordinates    ${entire_page}    300    300


Search desired product by name
    [Arguments]    ${name}
    SeleniumLibrary.Input text    ${search_input_box}    ${name}
    common_keywords.Click Element    ${search_button}
    Sleep    4s
    common_keywords.Verify Web Element Is Visible    ${prod_tag}
    ${expected_text}    String.Format String    ${result_text}    text=${name}
    ${result}    Get text and compare value     ${search_result_text}     ${expected_text}
    BuiltIn.Run Keyword If
    ...    ${result} == ${true}
    ...    BuiltIn.Log    Success to search products by text name
    ...    ELSE    
    ...    BuiltIn.Fail    Fail to search products by text name

Get text and compare value
    [Arguments]    ${locator}    ${text_value}
    ${text}    Get Text Element    ${locator}
    BuiltIn.Return From Keyword If
    ...    '${text}' == '${text_value}'    ${true}

Get text and search value
    [Arguments]    ${locator}    ${text_value}
    ${text}    Get Text Element    ${locator}
    ${status}    BuiltIn.Run Keyword And Return Status
    ...    BuiltIn.Should Contain    ${text}    ${text_value}
    BuiltIn.Return From Keyword     ${status}

Input data and verify text for web element
    [Arguments]     ${locator}      ${expect_text}
    SeleniumLibrary.Input Text     ${locator}    ${expect_text}
    ${real_text}=    SeleniumLibrary.Get Value    ${locator}
    Should Be Equal    '${real_text}'    '${expect_text}'

Compare and assert final result 
    [Arguments]    ${rs1}    ${rs2}
    Run Keyword If     ${rs1}==${true} and ${rs2}==${true}   BuiltIn.Log    Pass. Test case finish with no issue.
    ...    ELSE    BuiltIn.Fail    Fail. Some product not available on shopping cart!

Verify Web Element Is Visible
    [Arguments]     ${locator}
    SeleniumLibrary.Wait Until Page Contains Element    ${locator}    timeout=${GLOBALTIMEOUT}
    SeleniumLibrary.Wait Until Element Is Visible    ${locator}    timeout=${GLOBALTIMEOUT}

Click Element
    [Arguments]    ${locator}    ${timeout}=${GLOBALTIMEOUT}
    SeleniumLibrary.Wait Until Element Is Visible     ${locator}    timeout=${timeout}
    SeleniumLibrary.Click Element  ${locator}

Get Text Element
    [Arguments]    ${locator}    ${timeout}=${GLOBALTIMEOUT}
    SeleniumLibrary.Wait Until Element Is Visible     ${locator}    timeout=${timeout}
    ${text}    SeleniumLibrary.Get Text  ${locator}
    BuiltIn.Return From Keyword    ${text}

Select Checkbox Element
    [Arguments]    ${locator}    ${timeout}=${GLOBALTIMEOUT}
    SeleniumLibrary.Wait Until Element Is Visible     ${locator}    timeout=${timeout}
    SeleniumLibrary.Select checkbox  ${locator}

Scroll And Click Element
    [Arguments]    ${locator}
    Scroll To Element    ${locator}
    common_keywords.Click Element    ${locator}

Scroll To Element
    [Arguments]    ${locator}
    SeleniumLibrary.Scroll Element Into View    ${locator}

Select from drop down by label
    [Arguments]     ${locator}     ${label}
    common_keywords.Verify Web Element Is Visible   ${locator}
    Wait Until Keyword Succeeds    3x    5s    SeleniumLibrary.Select From List By Label   ${locator}    ${label}  

Scroll Down And Wait To Get Available Element
    [Arguments]    ${locator}
    ${section}     Set Variable     ${11}
    ${page_height}    SeleniumLibrary.Get Element Size     ${entire_page}
    ${page_height}    Set Variable    ${page_height}[1]
    ${scroll_length}    Evaluate     '${page_height}/${section}'
    FOR    ${index}  IN RANGE  ${section}
        SeleniumLibrary.Execute Javascript     window.scrollTo(0,${${scroll_length}*${index}})
        ${status}    Run Keyword And Return Status     SeleniumLibrary.Wait Until Element Is Visible     ${locator}     timeout=10
        BuiltIn.Return From Keyword If     '${status}' == '${true}'
    END
        BuiltIn.Fail     msg=Not found element in this page.

Click to shopping cart
    Sleep    5s
    ${text}    Get Text Element    ${shopping_cart_number}
    Log     Number of product right now in shopping cart is ${text}
    Click Element    ${shopping_cart_icon}

Search and add product to cart
    [Arguments]    ${search_field}    ${size}
    search_page.Search products by name and specificcation    ${search_field}    ${size}
    ${text}    search_page.Click particular product with SKU
    
    Close popup
    prod_detail_page.Check product name and add to cart     ${text}
    [Return]    ${text}