-- This function takes a phone number in various formats and transforms it into a standardized format.

CREATE FUNCTION FormatPhoneNumber(@inputNumber VARCHAR(20))
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @formattedNumber VARCHAR(20);

    -- Cleaning: Keep only digits
    SET @inputNumber = REPLACE(@inputNumber, '+', '');
    SET @inputNumber = REPLACE(@inputNumber, ' ', '');
    SET @inputNumber = REPLACE(@inputNumber, '(', '');
    SET @inputNumber = REPLACE(@inputNumber, ')', '');

    -- Length and alphanumeric characters check
    IF LEN(@inputNumber) < 9 OR PATINDEX('%[^0-9]%', @inputNumber) > 0
        RETURN NULL;

    -- Formatting
    SET @formattedNumber = '+994 (' + SUBSTRING(@inputNumber, LEN(@inputNumber) - 9 + 1, 2) + ') '
                            + SUBSTRING(@inputNumber, LEN(@inputNumber) - 7 + 1, 3) + ' '
                            + SUBSTRING(@inputNumber, LEN(@inputNumber) - 4 + 1, 2) + ' '
                            + SUBSTRING(@inputNumber, LEN(@inputNumber) - 2 + 1, 2);

    RETURN @formattedNumber;
END;



-- Test Cases

-- Valid number
DECLARE @inputNumber1 VARCHAR(20) = '994501112222';
DECLARE @result1 VARCHAR(20);

SET @result1 = dbo.FormatPhoneNumber(@inputNumber1);
PRINT N'Input Number: ' + @inputNumber1;
PRINT N'Formatted Number: ' + ISNULL(@result1, N'Invalid Number');
PRINT '';

-- Valid number without country code
DECLARE @inputNumber2 VARCHAR(20) = '0501112222';
DECLARE @result2 VARCHAR(20);

SET @result2 = dbo.FormatPhoneNumber(@inputNumber2);
PRINT N'Input Number: ' + @inputNumber2;
PRINT N'Formatted Number: ' + ISNULL(@result2, N'Invalid Number');
PRINT '';

-- Invalid short number
DECLARE @inputNumber3 VARCHAR(20) = '050111';
DECLARE @result3 VARCHAR(20);

SET @result3 = dbo.FormatPhoneNumber(@inputNumber3);
PRINT N'Input Number: ' + @inputNumber3;
PRINT N'Formatted Number: ' + ISNULL(@result3, N'Invalid Number');
PRINT '';

-- Invalid alphanumeric characters
DECLARE @inputNumber4 VARCHAR(20) = '9940A1B12222';
DECLARE @result4 VARCHAR(20);

SET @result4 = dbo.FormatPhoneNumber(@inputNumber4);
PRINT N'Input Number: ' + @inputNumber4;
PRINT N'Formatted Number: ' + ISNULL(@result4, N'Invalid Number');
PRINT '';

-- Invalid single character
DECLARE @inputNumber5 VARCHAR(20) = '+';
DECLARE @result5 VARCHAR(20);

SET @result5 = dbo.FormatPhoneNumber(@inputNumber5);
PRINT N'Input Number: ' + @inputNumber5;
PRINT N'Formatted Number: ' + ISNULL(@result5, N'Invalid Number');
PRINT '';
