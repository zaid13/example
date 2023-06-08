using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.NetworkInformation;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Windows.Devices.Bluetooth;
using Windows.Devices.Bluetooth.Advertisement;
using Windows.Devices.Bluetooth.GenericAttributeProfile;
using Windows.Devices.Enumeration;
using Windows.Storage.Streams;
using System;
using System.IO;


namespace QuickBlueToothLE
{
    class Program
    {

        static DeviceInformation device = null;
        static GattServiceProvider serviceProvider;



        static async Task Main(string[] args)
        {

            BluetoothLEAdvertisementWatcher watcher;
            Guid uuid = Guid.NewGuid();
            Guid uuid1 = Guid.NewGuid();
            Guid uuid2 = Guid.NewGuid();
            Guid uuid3 = Guid.NewGuid();



            GattServiceProviderResult result = await GattServiceProvider.CreateAsync(uuid);

            GattLocalCharacteristicParameters Readparameters = new GattLocalCharacteristicParameters
            {
                CharacteristicProperties = GattCharacteristicProperties.Read ,
                ReadProtectionLevel = GattProtectionLevel.Plain,
                WriteProtectionLevel = GattProtectionLevel.Plain
            };


            GattLocalCharacteristicParameters BroadcastParameters = new GattLocalCharacteristicParameters
            {
                CharacteristicProperties = GattCharacteristicProperties.BroadcastParameters ,
                ReadProtectionLevel = GattProtectionLevel.Plain,
                WriteProtectionLevel = GattProtectionLevel.Plain
            };

            GattLocalCharacteristicParameters Writeparameters = new GattLocalCharacteristicParameters
            {
                CharacteristicProperties = GattCharacteristicProperties.Write,
                ReadProtectionLevel = GattProtectionLevel.Plain,
                WriteProtectionLevel = GattProtectionLevel.Plain
            };


            PhysicalAddress address = GetBTMacAddress();

            Console.WriteLine(address);





            if (result.Error == BluetoothError.Success)
            {
                Console.WriteLine(result.ServiceProvider);
                Console.WriteLine(uuid);
                Console.WriteLine(uuid1);
                Console.WriteLine(uuid2);
                serviceProvider = result.ServiceProvider;

            }


            GattLocalCharacteristicResult characteristicResult = await serviceProvider.Service.CreateCharacteristicAsync(uuid1, Readparameters);
            if (characteristicResult.Error != BluetoothError.Success)
            {
                Console.WriteLine("ERROR");
                // An error occurred.
                return;
            }
            GattLocalCharacteristic _readCharacteristic = characteristicResult.Characteristic;
            _readCharacteristic.ReadRequested += ReadCharacteristic_ReadRequested;




            GattLocalCharacteristicResult writecharacteristicResult = await serviceProvider.Service.CreateCharacteristicAsync(uuid2, Writeparameters);
            if (characteristicResult.Error != BluetoothError.Success)
            {
                Console.WriteLine("ERROR");
                // An error occurred.
                return;
            }
            GattLocalCharacteristic _writeCharacteristic = writecharacteristicResult.Characteristic;
            _writeCharacteristic.WriteRequested += WriteCharacteristic_WriteRequested;





            GattServiceProviderAdvertisingParameters advParameters = new GattServiceProviderAdvertisingParameters
            {
                IsDiscoverable = true,
                IsConnectable = true,


            };

            watcher = new BluetoothLEAdvertisementWatcher();
            watcher.Received += Watcher_Received;

            watcher.Start();


            serviceProvider.StartAdvertising(advParameters);

            Console.ReadLine();
            serviceProvider.StopAdvertising();


        }
        private static async void Watcher_Received(BluetoothLEAdvertisementWatcher sender, BluetoothLEAdvertisementReceivedEventArgs args)
        {
            // Retrieve information about the device and connection
            var device = await BluetoothLEDevice.FromBluetoothAddressAsync(args.BluetoothAddress);
            //     var deviceName = device.BluetoothDeviceId;
            var timestamp = DateTime.Now;


            if (device != null)
            {
              //  Console.WriteLine($"New connection: Device={args.BluetoothAddress}, Timestamp={timestamp}");
                //Console.WriteLine($"{device.DeviceId} , {device.ConnectionStatus}");
            }


            // Log the new connection

        }
        private static async void WriteCharacteristic_WriteRequested(GattLocalCharacteristic sender, GattWriteRequestedEventArgs args)
        {
            GattWriteRequestedEventArgs requestedArgs = args;

            // Read the data from the write request
            GattWriteRequest request = await requestedArgs.GetRequestAsync();
            if (request != null)
            {
                byte[] data = new byte[request.Value.Length];
                DataReader.FromBuffer(request.Value).ReadBytes(data);

                Console.WriteLine("Received data: " + BitConverter.ToString(data));

                // Process the data as needed
                // ...

                // Respond to the write request (optional)
                //     request.Respond();
            }



        }

        async static void ReadCharacteristic_ReadRequested(GattLocalCharacteristic sender, GattReadRequestedEventArgs args)
        {
            GattReadRequestedEventArgs requestedArgs = args;

            var deferral = requestedArgs.GetDeferral();
            // Create a response to the read request
            GattReadRequest request = await requestedArgs.GetRequestAsync();

            string file_content = "empty ";

            if (request != null)
            {
                try
                {
                    // Open the text file using a stream reader.
                    using (var sr = new StreamReader("C:\\ble-reading\\txt.txt"))
                    {
                        // Read the stream as a string, and write the string to the console.
                    //    Console.WriteLine(sr.ReadToEnd());
                        file_content = sr.ReadToEnd();
                    }
                }
                catch (IOException e)
                {
                    Console.WriteLine("The file could not be read:");
                    Console.WriteLine(e.Message);

                    Console.WriteLine($"read \n");
                    // Prepare the data to be sent in response to the read request
                    byte[] data1 = Encoding.UTF8.GetBytes
                        ("Unable to read file ");

                    // Set the value of the characteristic with the prepared data
                    DataWriter writer1 = new DataWriter();
                    writer1.WriteBytes(data1);
                    request.RespondWithValue(writer1.DetachBuffer());

                    deferral.Complete();
                }


                // Read the stream as a string, and write the string to the console.

                byte[] data = Encoding.UTF8.GetBytes(file_content);

                Console.WriteLine($"read \n");


                // Set the value of the characteristic with the prepared data
                DataWriter writer = new DataWriter();
                writer.WriteBytes(data);
                request.RespondWithValue(writer.DetachBuffer());
                deferral.Complete();




            }
        }





        public static PhysicalAddress GetBTMacAddress()
        {

            foreach (NetworkInterface nic in NetworkInterface.GetAllNetworkInterfaces())
            {

                // Only consider Bluetooth network interfaces
                if (nic.NetworkInterfaceType != NetworkInterfaceType.FastEthernetFx &&
                    nic.NetworkInterfaceType != NetworkInterfaceType.Wireless80211)
                {

                    return nic.GetPhysicalAddress();
                }
            }
            return null;
        }


    }


}


