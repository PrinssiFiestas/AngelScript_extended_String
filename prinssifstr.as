/* **************************************************************************
 *
 *      String datatype with extended functionality for AngelScript
 *
 *      Highly inspired by Ruby string
 *      
 *      The functionality of AngelScripts native string is almost duplicated. 
 *      Methods with capitalized names modify original string while 
 *      uncapitalized create copies. 
 * 
 *      Backwards compatible with AngelScript string. All methods can take 
 *      standard strings as arguments. 
 *
 * *************************************************************************/

namespace PrinssiF
{
    class String
    {
        private string str;
        private uint lengthOfString;
        uint length
        {
            get const{return lengthOfString;}
            set{str.resize(value); lengthOfString = value;}
        }

        /* Constructors allowing implicit casting from AngelScript datatypes */
        String(){}
        String(const string &in s){str = s; length = str.length;}
        String(const double &in d){str = d; length = str.length;}
        String(const bool &in b){str = b; length = str.length;}
        String(const dictionaryValue &in d){str = string(d); length = str.length;}
        String(const String &in other){str = other.str; length = str.length;}

        /* Duplicating functionality of AngelScript string */
        String opAssign(const string &in rhs){str = rhs; length = str.length; return this;}
        String opAdd(const String &in rhs) const {string str_temp = str + rhs.str; return str_temp;}
        String opAddAssign(const String &in rhs){this = this + rhs; return this;}
        bool opEquals(const String &in rhs) const {return str == rhs.str;}
        int opCmp(const String &in rhs) const {return str == rhs.str ? 0 : (str > rhs.str ? -1 : 1);}
        bool isEmpty() const {return str.isEmpty();}
        int findFirst(const string &in str_temp, uint start = 0) const {return str.findFirst(str_temp, start);}
        int findLast(const string &in str_temp, int start = -1) const {return str.findLast(str_temp, start);}
        int findFirstOf(const string &in chars, int start = 0) const {return str.findFirstOf(chars, start);}
        int findFirstNotOf(const string &in chars, int start = 0) const {return str.findFirstNotOf(chars, start);}
        int findLastOf(const string &in chars, int start = -1) const {return str.findLastOf(chars, start);}
        int findLastNotOf(const string &in chars, int start = -1) const {return str.findLastNotOf(chars, start);}
        array<String>@ split(const string &in delimiter = " ") const
        {
            array<string> stringArrayBuffer = str.split(delimiter);
            array<String> outputArrayBuffer(stringArrayBuffer.length);
            for(uint i=0; i<stringArrayBuffer.length; i++)
            {
                outputArrayBuffer[i] = stringArrayBuffer[i];
            }
            return outputArrayBuffer;
        }
        // Implicit casting from PrinssiF::String to AngelScript string when required
        string opImplConv() const {return str;}




        /* ******************************************************************
         *   Modified or added operator and method overloads
         * ******************************************************************/




        // "-"-operator overload
        // Find right hand side String from left hand side String and delete it if found
        String opSub(const String &in rhs) const
        {
            string str_temp = str;
            int rhsPosition = str_temp.findLast(rhs);
            if(rhsPosition>=0){str_temp.erase(rhsPosition, rhs.length);}
            return str_temp;
        }
        // "-="-operator overload
        String opSubAssign(const String &in rhs){this = this - rhs; return this;}

        // "*"-operator overload
        // Ruby-style string multiplication returns original string appended to itself n-1 number of times 
        String opMul(const int &in rhs) const
        {
            if(rhs<=0){return "";}
            string str_temp = str;
            for(int i=1; i < rhs; i++){str_temp += str_temp;}
            return str_temp;
        }
        String opMul_r(const int &in lhs) const {return this*lhs;}

        // "*="-operator overload
        String opMulAssign(const int &in rhs){this = this*rhs; return this;}

        // "[]"-operator overload
        // Return a character at i with someString[i] or substring between i and j with someString[i,j]
        String opIndex(const uint &in i, int j=-1) const {j = j==-1 ? 1 : j-i+1; return str.substr(i,j);}

        // "()"-operator overload
        // Same as "[]" except modifies original string
        String opCall(const uint &in i, int j=-1){j = j==-1 ? 1 : j-i+1; this = str.substr(i,j); return this;}

        // Capitalized versions of these methods function identically to non-capitalized AngelScript methods. 
        // Non-capitalized methods return a modified version, but dont modify the originals. 
        String resize(const uint &in newLenght) const {String str_temp = str; str_temp.length = newLenght; return str_temp;}
        String Resize(const uint &in newLenght){this.length = newLenght; return this;}
        String insert(const string &in other, uint pos = 0) const {string str_temp = str; str_temp.insert(pos, other); return str_temp;}
        String insert(const uint &in pos, const string &in other) const {string str_temp = str; str_temp.insert(pos, other); return str_temp;}
        String Insert(const string &in other, uint pos = 0){str.insert(pos, other); length = str.length; return this;}
        String Insert(const uint &in pos, const string &in other){str.insert(pos, other); length = str.length; return this;}
        String erase(const uint &in pos, int count = -1) const {string str_temp = str; str_temp.erase(pos, count); return str_temp;}
        String Erase(const uint &in pos, int count = -1){str.erase(pos, count); length = str.length; return this;}
        String substr(uint start = 0, int count = -1) const {String str_temp = str.substr(start, count); return str_temp;}
        String Substr(uint start = 0, int count = -1) {str = str.substr(start, count); length = str.length; return this;}





        /* ******************************************************************
         *      Custom methods
         * *****************************************************************/




        // Ruby-style method to erase new line or argument at the end of String
        String Chomp(String separator = "") 
        {
            if(separator.isEmpty())
            {
                String lastChar = this[length-1];
                if(lastChar=="\n")
                {
                    this -= lastChar;
                    lastChar = this[length-1];
                    if(lastChar=="\r"){this-=lastChar;}
                }
                else if(lastChar=="\r")
                {
                    this -= lastChar;
                }
            }
            else
            {
                String endOfString = str.substr(str.length-separator.length, separator.length);
                if(separator==endOfString){this-=separator;}
            }

            return this;
        }
        String chomp(String separator = "") const
        {
            String str_temp = this;
            return str_temp.Chomp(separator);
        }

        // Ruby-style method to erase last character
        String Chop(){return this.isEmpty() ? this : this.Erase(length-1);}
        String chop() const {String str_temp = this; return str_temp.Chop();}

        // Python-style method to count substring occurrences
        uint count(const string &in substr, uint start=0) const
        {
            uint substrCount = 0;
            while(true)
            {
                start = str.findFirst(substr, start) + 1;
                if(start<=0){break;}
                substrCount++;
            }
            return substrCount;
        }

        // Simplified Ruby-style method to delete all occurrences of String passed as argument
        String Delete(const String &in other)
        {
            while(this.findFirst(other)>=0){this -= other;}
            return this;
        }
        String delete(const String &in other) const {String str_temp = this; return str_temp.Delete(other);}

        // Finds and returns the first opening bracket position after start argument that matches the bracket passed as first argument. 
        // Multiple bracket types can be passed as argument. It just finds the first matching one. 
        // Method only takes into account bracket shape so whether opening or closing bracket is passed as argument is irrelevant. 
        int findOpening(String bracket = "([{", int start = 0)
        {
            String bracketToFind = "";
            array<String> brackets = {"()", "[]", "{}"};
            for(uint i=0; i<brackets.length; i++)
            {
                if(bracket.findFirstOf(brackets[i]) >= 0){bracketToFind += brackets[i][0];}
            }
            return this.findFirstOf(bracketToFind, start);
        }

        // Similar to findOpening() except finds first closing bracket instead of opening
        int findClosing(String bracket = "([{", int start = 0)
        {
            String bracketToFind = "";
            array<String> brackets = {"()", "[]", "{}"};
            for(uint i=0; i<brackets.length; i++)
            {
                if(bracket.findFirstOf(brackets[i]) >= 0){bracketToFind += brackets[i][1];}
            }
            return this.findFirstOf(bracketToFind, start);
        }

        // Finds and returns matching closing bracket position for bracket passed as first argument
        // An example use case would be to find code blocks when used with findOpening()
        int findClosingFor(int openingPos = 0)
        {
            openingPos = this.findOpening("([{",openingPos);
            if(openingPos<0){return -1;}
            String opening = this[openingPos];
            dictionary closingFor = {{"(",")"}, {"[","]"}, {"{","}"}};
            String closing = closingFor[opening];
            int closingPos = -1;
            uint openingCount = 0;
            uint closingClount = 0;
            for(uint i = openingPos; i<this.length; i++)
            {
                if(this[i]==opening)
                {
                    openingCount++;
                    continue;
                }
                if(this[i]==closing)
                {
                    closingClount++;
                    if(closingClount==openingCount){closingPos = i; break;}
                }
            }
            return closingPos;
        }

        // Returns true if String passed as argument is found
        bool includes(const String &in other){return str.findFirst(other)>=0;}

        // Removes leading whitespaces
        String Lstrip()
        {
            if(this.isEmpty()){return this;}
            const string whitespaceChars = "\x00\t\n\r ";
            string firstChar;
            while(true)
            {
                firstChar = this[0];
                if(whitespaceChars.findFirst(firstChar)>=0){this.Erase(0,1); continue;}
                else{break;}
            }
            return this;
        }
        String lstrip() const {String str_temp = this; return str_temp.Lstrip();}

        // Finds first substr and replace it with replacement
        String ReplaceFirst(const String &in substr, const String &in replacement)
        {
            int substrPosition = this.findFirst(substr);
            if(substrPosition >= 0)
            {
                String strBeginning = this[0,substrPosition];
                String strEnding = this.substr(substrPosition + substr.length);

                this = strBeginning + replacement + strEnding;
            }
            return this;
        }
        String replaceFirst(const String &in substr, const String &in replacement) const
        {
            String str_temp = this;
            return str_temp.ReplaceFirst(substr, replacement);
        }

        // Finds last substr and replace it with replacement
        String ReplaceLast(const String &in substr, const String &in replacement)
        {
            int substrPosition = this.findLast(substr);
            if(substrPosition >= 0)
            {
                String strBeginning = this[0,substrPosition];
                String strEnding = this.substr(substrPosition + substr.length);

                this = strBeginning + replacement + strEnding;
            }
            return this;
        }
        String replaceLast(const String &in substr, const String &in replacement) const
        {
            String str_temp = this;
            return str_temp.ReplaceLast(substr, replacement);
        }

        // Replaces all substr occurrences with replacement
        String Replace(const String &in substr, const String &in replacement)
        {
            while(this.findFirst(substr)>=0){this.ReplaceFirst(substr, replacement);}
            return this;
        }
        String replace(const String &in substr, const String &in replacement) const
        {
            String str_temp = this;
            return str_temp.Replace(substr, replacement);
        }

        // Reverses String. Pretty self explanatory. 
        String reverse() const
        {
            string reversedStr = "";
            for(int i = length-1; i>=0; i--)
            {
                reversedStr += str.substr(i, 1);
            }
            return reversedStr;
        }
        String Reverse(){return this = this.reverse();}

        // Removes trailing whitespaces
        String Rstrip(){this = this.Reverse().Lstrip().Reverse(); return this;}
        String rstrip() const {String str_temp = this; return str_temp.Rstrip();}

        // Removes leading and trailing whitespaces
        String Strip(){this = this.Lstrip().Rstrip(); return this;}
        String strip() const {String str_temp = this; return str_temp.Strip();}
    }




    /* **********************************************************************
     *              PrinssiF::String Functions
     * *********************************************************************/




    // Explicit casting from AngelScript datatypes to PrinssiF::String
    String Str(const string &in strToCast){return strToCast;}
    String Str(const double &in d){return d;}
    String Str(const bool &in b){return b;}
    String Str(const dictionaryValue &in dictValue){return string(dictValue);}

    // Returns concatenated Strings from an array
    String join(const array<String> &in arr, const string &in delimiter)
    {
        String str_temp = "";
        for(uint i=0; i<arr.length; i++){str_temp += arr[i] + delimiter;}
        return str_temp - delimiter;
    }

    // Easy to use printing function that does type casting with PrinssiF::String constructors
    void Print(const String &in strOut){print(strOut);}

    // Helper class to make printMax() pseudofunction below
    // Standard AngelScript string and print() used for better performance in real time processing loops
    class Printer
    {
        uint printCount = 0;
        uint maxPrintTimes = 100;

        void prnt(const string &in strOut)
        {
            if(!strOut.isEmpty() && printCount<maxPrintTimes)
            {
                printCount++;
                print(strOut);
            }
        }
        Printer& opCall(const uint &in maxTimes, string strOut="")
        {
            maxPrintTimes = maxTimes;
            this.prnt(strOut);
            return this;
        }
        void times(const string &in strOut)
        {
            this.prnt(strOut);
        }
        void resetPrintCount()
        {
            printCount = 0;
        }
    }
    // Pseudofunction to limit prints in loops
    // Use with syntax printMax(uint printTimes).times(string toPrint) or printMax(uint printTimes, string toPrint)
    Printer printMax;
}