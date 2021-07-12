*** Setting ***
Resource    ${CURDIR}/../keywords/web_resources_import.robot 
Suite Teardown    Close All Browsers

*** Variables ***
${type1}    44 - 55
${type2}    32 - 43
${search_field}    TV

*** Test Cases ***
Add products then checking shopping cart
    [Tags]    web    search TV
    Open browser to page    ${pb_url}
    ${product_1}    common_keywords.Search and add product to cart    ${search_field}    ${type1}
    ${product_2}    common_keywords.Search and add product to cart    ${search_field}    ${type2}
    common_keywords.Click to shopping cart
    ${check_point1}      cart_page.Check product is existed on cart    ${product_1}
    ${check_point2}      cart_page.Check product is existed on cart    ${product_2}
    Compare and assert final result     ${check_point1}    ${check_point2}