import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/transceiver_controller.dart';
import '../../services/p2p_network_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _ipController = TextEditingController(text: "192.168.1.100");

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransceiverController>();
    final network = controller.networkService;

    return Scaffold(
      appBar: AppBar(
        title: const Text("P2P Network Transceiver Setup"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Connection Mode Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "P2P TRANSPORT PROTOCOL",
                    style: TextStyle(color: AppTheme.activeGreen, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  RadioListTile<P2pProtocol>(
                    title: const Text("Wi-Fi Direct / Local IP Sockets", style: TextStyle(color: AppTheme.textPrimary)),
                    subtitle: const Text("High throughput, lowest latency (< 15ms)", style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                    value: P2pProtocol.wifiDirect,
                    groupValue: network.protocol,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => network.setProtocol(val));
                      }
                    },
                  ),
                  RadioListTile<P2pProtocol>(
                    title: const Text("Bluetooth RFCOMM Stream", style: TextStyle(color: AppTheme.textPrimary)),
                    subtitle: const Text("Zero-config offline pairing without Wi-Fi router", style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                    value: P2pProtocol.bluetoothRfcomm,
                    groupValue: network.protocol,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => network.setProtocol(val));
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Role 1: Host Server (Phone A)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.wifi_tethering, color: AppTheme.primaryColor),
                      SizedBox(width: 8),
                      Text(
                        "PHONE A: START P2P HOST SERVER",
                        style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Listens on port 8888 for incoming P2P transceiver audio packets from Phone B.",
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text("Start Host Listener", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        await controller.startP2pHost();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("P2P Host Server started on port 8888")),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Role 2: Connect to Host (Phone B)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.phonelink_ring, color: AppTheme.activeGreen),
                      SizedBox(width: 8),
                      Text(
                        "PHONE B: CONNECT TO PHONE A",
                        style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ipController,
                    decoration: const InputDecoration(
                      labelText: "Phone A IP Address",
                      labelStyle: TextStyle(color: AppTheme.textSecondary),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lan, color: AppTheme.textSecondary),
                    ),
                    style: const TextStyle(color: AppTheme.textPrimary),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.activeGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.link, color: Colors.white),
                      label: const Text("Connect to Host", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        final ip = _ipController.text.trim();
                        if (ip.isNotEmpty) {
                          await controller.connectP2pPeer(ip);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Connecting to P2P Host $ip...")),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
