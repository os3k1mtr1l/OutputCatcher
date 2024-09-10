#include"../outputcatcher.h"

#ifdef _WIN32
    #include<windows.h>
    #include<shlwapi.h>
    #include<locale>
    #include<codecvt>

    void OutputCatcher::m_GetExecutableName() 
    {
        char* path = new char[MAX_PATH];

        GetModuleFileNameA(NULL, path, MAX_PATH);
        std::string executable_name = PathFindFileNameA(path);

        delete[] path;
        
        m_log_file_name += executable_name;
    }

#elif defined(__linux__) || defined(__gnu_linux__)
    #include <unistd.h>
    #include <limits.h>
    #include <libgen.h>

    void OutputCatcher::m_GetExecutableName()
    {
        char path[PATH_MAX];
        ssize_t len = ::readlink("/proc/self/exe", path, sizeof(path) - 1);
        if (len != -1)
        {
            path[len] = '\0';
            std::string executable_name = std::string(basename(path));
            m_log_file_name += executable_name;
        }
    }
#else
    #error "Unsupported platform"
#endif

void OutputCatcher::m_GetTimeNow()
{
    std::time_t now = std::time(NULL);

    std::tm* local_time = std::localtime(&now);

    std::ostringstream oss;
    oss<<std::put_time(local_time, "%Y-%m-%d_%H:%M:%S");

    m_log_file_name += oss.str();
}

OutputCatcher::OutputCatcher()
{   
    m_log_file_name = "log_";

    m_GetExecutableName();
    m_GetTimeNow();

    m_log_file_name += ".txt";

    m_original_stdout = stdout;
    freopen(m_log_file_name.c_str(), "w", stdout);
}

OutputCatcher::~OutputCatcher()
{
    fflush(stdout);
    
    if (m_original_stdout)
    {
        freopen(CONSOLE_STDOUT, "w", stdout);
    }
}