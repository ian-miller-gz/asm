#include <iostream>
#include <stdlib.h>
#include <bitset>


extern "C" int hewo();
extern "C" int puzzle(int x);


const int FIRST_ARGUMENT = 1;
const int COUNT_ONE_ARGUMENT = 2;


int main(int argc, char* argv[]){
if (argc != COUNT_ONE_ARGUMENT) {
  std::cout << "Invalid number of arguments!" << std::endl;
  return 1;}
// hewo();
std::bitset<8> x(puzzle(std::atoi(argv[FIRST_ARGUMENT])));
std::cout << x << std::endl;;
return 0; }