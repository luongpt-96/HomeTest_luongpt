*** Setting ***
Resource    ${CURDIR}/../web_resources_import.robot

*** Variables ***
${product_name_title}    css:#link-brandName-productDetail+span
${product_add_cart_btn}    css:div[class='ProductSummary__StickyBarView-ccTufv bHNIjO'] * button
${product_pick_up_btn}    css:div[class='Col__Column-sc-1619uro-0 cPDxnm'] * button

***Keyword***
Check product name and add to cart 
    [Arguments]    ${product_name}
    ${result}    common_keywords.Get text and compare value    ${product_name_title}    ${product_name}
    BuiltIn.Run Keyword If    ${result}==${true}
    ...    common_keywords.Click Element    ${product_add_cart_btn}
    ...    ELSE    BuiltIn.Fail    Not same the expected product, refused!