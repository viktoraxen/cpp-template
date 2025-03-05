#include <iostream>

int main(int argc, char* argv[])
{
    if (argc > 1)
    {
        std::string input = argv[1];
        freopen(input.c_str(), "r", stdin);
    }

    return 0;
}
