#include <iostream>

extern "C" char* ReadDrive(char* driveName);

int main()
{
	char driveName[] = "\\\\.\\C:";
	char* sector = ReadDrive(driveName);
	for (int i = 0; i < 512; i++)
	{
		printf(" %08x ", *sector);
		sector++;
	}
	return 0;
}