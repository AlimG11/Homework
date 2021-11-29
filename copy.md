Main
```
#include "BMPstruct.h"
#include "StructH.h"
#include <fstream>
#include <iostream>

int main()
{
	rgbImg img;
	img = read_rgb_bitmap("IZO.bmp");
	write_rgb_bitmap("result.bmp",img);
	img_rot180(img);

	delete_img(img);
	std::system("pause");
}

```
BMPStruct.h
```
#pragma once

typedef unsigned short WORD; // 2 байта
typedef unsigned int DWORD; // 4 bytes
typedef int LONG; 
typedef unsigned char BYTE; // 1 byte

#pragma pack(push,1)
struct BITMAPFILEHEADER {
	WORD bfType;
	DWORD bfSize;
	WORD bfReserved1;
	WORD bfReserved2;
	DWORD bfOffBits;
};

struct BITMAPINFOHEADER {
	DWORD biSize; // размер структуры в байтах
	LONG biWidth;
	LONG biHeight;
	WORD biPlanges; //Всегда 1
	WORD biBitCount; //Кол-во бит на цвет 0 | 1 | 4 | 8 | 16 | 24 | 32
	DWORD biCompression;
	DWORD biSizeImage;
	LONG biXPelsPerMeter; //горизонтальное разришение
	LONG biYPelsPerMeter; //вертикальное разрешение
	DWORD biClrUsed;
	DWORD biClrImportant;
};

struct RGB {
	BYTE Blue;
	BYTE Green;
	BYTE Red;
};

struct rgbImg {
	RGB ** pixels;
	DWORD width;
	DWORD height;
};
#pragma pack(pop)
```
Struct.h
```
#pragma once
#include "BMPstruct.h"

int get_offset(int width);
rgbImg read_rgb_bitmap(const char filename[]);
void write_rgb_bitmap(const char filename[], const rgbImg & img);
void delete_img(rgbImg & img);
void img_rot180(rgbImg & img);

template <typename T>
void reverse_array(T* A, size_t Len) {
	if (Len > 0) {
		for (size_t i = 0, j = Len - 1; i < j; ++i, --j) std::swap(A[i], A[j]);
	}
}
```
Function.cpp
```
#include "StructH.h"
#include <fstream>
#include <exception>


int get_offset(int width) {
	int offset = 0;
	if (width % 4) offset = 4 - (3 * width) % 4;
	return offset;
};

rgbImg read_rgb_bitmap(const char filename[]) {
	std::ifstream inBMP(filename, std::ios_base::binary);
	if (!inBMP) {
		throw std::runtime_error ("Can not file ");
	}

	BITMAPFILEHEADER bmfh;
	inBMP.read((char *)&bmfh, sizeof(BITMAPFILEHEADER));


	BITMAPINFOHEADER bmih;
	inBMP.read((char *)&bmih, sizeof(BITMAPINFOHEADER));
	

	const int offset = get_offset(bmih.biWidth);
	rgbImg img;
	img.height = bmih.biHeight;
	img.width = bmih.biWidth;
	img.pixels = new RGB*[img.height];
	for (size_t row = 0; row < img.height; ++row) {
		img.pixels[row] = new RGB[img.width];
		for (size_t col = 0; col < img.width; ++col) {
			inBMP.read((char *)&img.pixels[row][col], sizeof(RGB));
		}
		inBMP.seekg(offset, std::ios_base::cur);
	}

	inBMP.close();
	return img;
}

void delete_img(rgbImg & img) {
	for (size_t i = 0; i < img.height; ++i) {
		delete[] img.pixels[i];
	}
	delete[] img.pixels;

	img.height = 0;
	img.width = 0;
	img.pixels = nullptr;
}

void write_rgb_bitmap(const char filename[], const rgbImg & img) {
	std::ofstream outBMP(filename, std::ios_base::binary);
	if (!outBMP) throw std::runtime_error("Failed to open output file");

	const int offset = get_offset(img.width);

	BITMAPFILEHEADER bmfh;
	char bfType[] = { 'B','A' };
	bmfh.bfType = *((WORD*)bfType);
	bmfh.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);
	bmfh.bfSize = img.height * img.width * 3 + bmfh.bfOffBits;
	WORD bfReserved1 = 0;
	WORD bfReserved2 = 0;
	
	outBMP.write((char *)&bmfh, sizeof(BITMAPFILEHEADER));

	BITMAPINFOHEADER bmih;

	bmih.biSize = sizeof (BITMAPINFOHEADER);
	bmih.biWidth = img.width;
	bmih.biHeight = img.height;
	bmih.biPlanges = 1; 
	bmih.biBitCount = 24;
	bmih.biCompression = 0;
	bmih.biSizeImage = bmfh.bfSize - bmfh.bfOffBits;
	bmih.biXPelsPerMeter = 1; 
	bmih.biYPelsPerMeter = 1; 
	bmih.biClrUsed = 0;
	bmih.biClrImportant = 0;

	outBMP.write((char *)&bmfh, sizeof(BITMAPINFOHEADER));

	BYTE* offset_array = new BYTE[offset];
	for (size_t i = 0; i < offset; ++i) offset_array[i] = 0;

	for (size_t row = 0; row < img.height; ++row) {
		for (size_t col = 0; col < img.width; ++col) {
			outBMP.write((char *)&img.pixels[row][col], sizeof(RGB));
		}
		outBMP.write((char *)offset_array, offset);
	}

	delete[] offset_array;
	outBMP.close();
}

void img_rot180(rgbImg & img) {
	for (size_t row = 0; row < img.height; ++row) {
		for (size_t col = 0; col < img.width; ++col) {
			reverse_array(img.pixels[row], img.width);
		}
		reverse_array(img.pixels, img.height);
	}
}

```


































