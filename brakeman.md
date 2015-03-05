# BRAKEMAN REPORT

| Application path                 | Rails version | Brakeman version | Started at                | Duration            |
|----------------------------------|---------------|------------------|---------------------------|---------------------|
| /home/ubuntu/workspace/c1_webapp | 4.2.0         | 3.0.1            | 2015-03-05 15:52:46 +0000 | 1.803126503 seconds |

| Checks performed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| BasicAuth, ContentTag, CreateWith, CrossSiteScripting, DefaultRoutes, Deserialize, DetailedExceptions, DigestDoS, EscapeFunction, Evaluation, Execute, FileAccess, FileDisclosure, FilterSkipping, ForgerySetting, HeaderDoS, I18nXSS, JRubyXML, JSONParsing, LinkTo, LinkToHref, MailTo, MassAssignment, ModelAttrAccessible, ModelAttributes, ModelSerialize, NestedAttributes, NumberToCurrency, QuoteTableName, Redirect, RegexDoS, Render, RenderDoS, RenderInline, ResponseSplitting, SQL, SQLCVEs, SSLVerify, SafeBufferManipulation, SanitizeMethods, SelectTag, SelectVulnerability, Send, SendFile, SessionSettings, SimpleFormat, SingleQuotes, SkipBeforeFilter, StripTags, SymbolDoSCVE, TranslateBug, UnsafeReflection, ValidationRegex, WithoutProtection, YAMLParsing |

### SUMMARY

| Scanned/Reported  | Total |
|-------------------|-------|
| Controllers       | 9     |
| Models            | 12    |
| Templates         | 36    |
| Errors            | 1     |
| Security Warnings | 1 (1) |

| Warning Type          | Total |
|-----------------------|-------|
| Remote Code Execution | 1     |

### Errors

| Error                                                                                                            | Location                                                                                  |
|------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| /home/ubuntu/workspace/c1_webapp/app/views/shared/_comment_field.html.erb:2 :: parse error on value ":" (tCOLON) | Could not parse /home/ubuntu/workspace/c1_webapp/app/views/shared/_comment_field.html.erb |

### SECURITY WARNINGS

| Confidence | Class           | Method | Warning Type                                                                                  | Message                                                                                                             |
|------------|-----------------|--------|-----------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| High       | RaterController | create | [Remote Code Execution](http://brakemanscanner.org/docs/warning_types/remote_code_execution/) | Unsafe reflection method constantize called with parameter value near line 5: `params[:klass].classify.constantize` |

