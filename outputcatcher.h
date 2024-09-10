#ifndef OUTPUTCATCHER_H
#define OUTPUTCATCHER_H
#include<cstdio>
#include<string>
#include<sstream>
#include<iomanip>


#ifdef _WIN32
    #define CONSOLE_STDOUT "CON"

    #ifdef MAKEDLL
        #define EXPORT __declspec(dllexport)
    #else
        #define EXPORT __declspec(dllimport)
    #endif

#elif defined(__linux__) || defined(__gnu_linux__)
    #define CONSOLE_STDOUT "/dev/tty"
    #define EXPORT __attribute__((visibility("default")))
    
#else
    #error "Unsupported platform"
#endif

class EXPORT OutputCatcher
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