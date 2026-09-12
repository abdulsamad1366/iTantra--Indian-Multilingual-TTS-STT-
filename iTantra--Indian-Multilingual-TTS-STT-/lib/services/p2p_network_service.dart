import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

enum ConnectionStatus {
  disconnected,
  connecting,
  connectedServer,
  connectedClient,
}

enum P2pProtocol {
  wifiDirect,
  bluetoothRfcomm,
}

abstract class P2pPacketListener {
  void onPacketReceived(Uint8List packetBytes);
  void onConnectionStateChanged(ConnectionStatus status, String? peerName);
}

class P2pNetworkService {
  static const int port = 8888;
  
  ServerSocket? _serverSocket;
  Socket? _clientSocket;
  ConnectionStatus _status = ConnectionStatus.disconnected;
  String? _connectedPeerName;
  P2pProtocol _protocol = P2pProtocol.wifiDirect;

  P2pPacketListener? listener;

  ConnectionStatus get status => _status;
  String? get connectedPeerName => _connectedPeerName;
  P2pProtocol get protocol => _protocol;

  void setProtocol(P2pProtocol protocol) {
    _protocol = protocol;
  }

  Future<bool> startServer() async {
    try {
      await stop();
      _serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
      _status = ConnectionStatus.connecting;
      debugPrint("P2P Transceiver Server listening on port $port...");

      _serverSocket?.listen((Socket socket) {
        _clientSocket = socket;
        _status = ConnectionStatus.connectedServer;
        _connectedPeerName = socket.remoteAddress.address;
        debugPrint("Phone connected from ${_connectedPeerName}:${socket.remotePort}");
        listener?.onConnectionStateChanged(_status, _connectedPeerName);

        socket.listen(
          (Uint8List data) {
            listener?.onPacketReceived(data);
          },
          onError: (error) {
            debugPrint("Socket error: $error");
            disconnectPeer();
          },
          onDone: () {
            debugPrint("Client disconnected");
            disconnectPeer();
          },
        );
      });

      return true;
    } catch (e) {
      debugPrint("Error starting P2P server: $e");
      _status = ConnectionStatus.disconnected;
      return false;
    }
  }

  Future<bool> connectToPeer(String hostAddress) async {
    try {
      _status = ConnectionStatus.connecting;
      listener?.onConnectionStateChanged(_status, hostAddress);

      _clientSocket = await Socket.connect(hostAddress, port, timeout: const Duration(seconds: 5));
      _status = ConnectionStatus.connectedClient;
      _connectedPeerName = hostAddress;
      debugPrint("Connected to P2P Host at $hostAddress");
      listener?.onConnectionStateChanged(_status, _connectedPeerName);

      _clientSocket?.listen(
        (Uint8List data) {
          listener?.onPacketReceived(data);
        },
        onError: (error) {
          debugPrint("Client Socket error: $error");
          disconnectPeer();
        },
        onDone: () {
          debugPrint("Host closed connection");
          disconnectPeer();
        },
      );

      return true;
    } catch (e) {
      debugPrint("Failed to connect to peer $hostAddress: $e");
      _status = ConnectionStatus.disconnected;
      listener?.onConnectionStateChanged(_status, null);
      return false;
    }
  }

  Future<bool> sendPacket(Uint8List packetBytes) async {
    if (_clientSocket != null && (_status == ConnectionStatus.connectedServer || _status == ConnectionStatus.connectedClient)) {
      try {
        _clientSocket?.add(packetBytes);
        await _clientSocket?.flush();
        return true;
      } catch (e) {
        debugPrint("Error sending packet: $e");
      }
    }
    debugPrint("Cannot send packet: Not connected to peer");
    return false;
  }

  void disconnectPeer() {
    _clientSocket?.destroy();
    _clientSocket = null;
    _status = _serverSocket != null ? ConnectionStatus.connecting : ConnectionStatus.disconnected;
    _connectedPeerName = null;
    listener?.onConnectionStateChanged(_status, null);
  }

  Future<void> stop() async {
    disconnectPeer();
    await _serverSocket?.close();
    _serverSocket = null;
    _status = ConnectionStatus.disconnected;
  }
}
