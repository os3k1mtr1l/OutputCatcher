#ifndef OUTPUTCATCHER_H
#define OUTPUTCATCHER_H
#include<cstdio>
#include<string>
#include<sstream>
#include<iomanip>

#ifdef _WIN32
    #define CONSOLE_STDOUT "CON"

#elif defined(__linux__) || defined(__gnu_linux__)
    #define CONSOLE_STDOUT "/dev/tty"

#else
    #error "Unsupported platform"
#endif

class OutputCatcher
{
    public:
        OutputCatcher();
        ~OutputCatcher();
    
    private:
        void m_GetExecutableName();
        void m_GetTimeNow();

        FILE* m_original_stdout;
        std::string m_log_file_name;
};

#endif