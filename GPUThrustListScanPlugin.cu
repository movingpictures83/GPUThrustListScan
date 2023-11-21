#include <thrust/device_vector.h>
#include <thrust/host_vector.h>

#include "GPUThrustListScanPlugin.h"

void GPUThrustListScanPlugin::input(std::string inputfile) {
   readParameterFile(inputfile);
}

void GPUThrustListScanPlugin::run() {}

void GPUThrustListScanPlugin::output(std::string outfile) {


  float *hostInput, *hostOutput; // The input 1D list
  int num_elements;              // number of elements in the input list
  num_elements = atoi(myParameters["N"].c_str());
  hostInput = (float*) malloc (num_elements*sizeof(float));
  std::ifstream myinput((std::string(PluginManager::prefix())+myParameters["data"]).c_str(), std::ios::in);
 int i;
 for (i = 0; i < num_elements; ++i) {
        int k;
        myinput >> k;
        hostInput[i] = k;
 }

  hostOutput = (float *)malloc(num_elements * sizeof(float));

  // Declare and allocate thrust device input and output vectors
  //@@ Insert code here
  thrust::device_vector<float> deviceInput(num_elements);
  thrust::device_vector<float> deviceOutput(num_elements);
  thrust::copy(hostInput, hostInput + num_elements, deviceInput.begin());

  thrust::inclusive_scan(deviceInput.begin(), deviceInput.end(),
                         deviceOutput.begin());
  thrust::copy(deviceOutput.begin(), deviceOutput.end(), hostOutput);

          std::ofstream outsfile(outfile.c_str(), std::ios::out);
        int j;
        for (i = 0; i < num_elements; ++i){
                outsfile << hostOutput[i];//std::setprecision(0) << a[i*N+j];
                outsfile << "\n";
        }


  free(hostInput);
  free(hostOutput);

}


PluginProxy<GPUThrustListScanPlugin> GPUThrustListScanPluginProxy = PluginProxy<GPUThrustListScanPlugin>("GPUThrustListScan", PluginManager::getInstance());
