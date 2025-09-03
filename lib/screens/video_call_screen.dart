/*import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

const String appId = '25b5c1a63fd34fb2afe3bcf7f96d40f9';
const String channelName = 'healthsaathi_channel';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  RtcEngine? _engine;
  int? _remoteUid;
  bool _joined = false;
  bool _muted = false;
  bool _videoDisabled = false;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    // Check permission statuses
    final cameraStatus = await Permission.camera.status;
    final micStatus = await Permission.microphone.status;

    // Request permissions if not granted
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
    if (!micStatus.isGranted) {
      await Permission.microphone.request();
    }

    // Recheck permissions after requesting
    if (!await Permission.camera.isGranted ||
        !await Permission.microphone.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera and microphone permissions are required.'),
          ),
        );
      }
      return;
    }

    try {
      // No need to check for AgoraRtcEngine.create in the current SDK.

      // Initialize Agora engine
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(const RtcEngineContext(appId: appId));

      // Set up for two-way video chat
      await _engine!
          .setChannelProfile(ChannelProfileType.channelProfileCommunication);
      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      // Register event handlers
      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            if (mounted) {
              setState(() => _joined = true);
            }
          },
          onUserJoined: (connection, uid, elapsed) {
            if (mounted) {
              setState(() => _remoteUid = uid);
            }
          },
          onUserOffline: (connection, uid, reason) {
            if (mounted) {
              setState(() => _remoteUid = null);
            }
          },
        ),
      );

      // Enable video and start preview
      await _engine!.enableVideo();
      await _engine!.startPreview();

      // Join the channel
      await _engine!.joinChannel(
        token: '', // Replace with a valid token if required
        channelId: channelName,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing Agora: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Call')),
      body: (_engine == null || !_joined)
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Show remote video if user joined, else show message
                if (_remoteUid != null)
                  AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _engine!,
                      canvas: VideoCanvas(uid: _remoteUid),
                      connection: RtcConnection(channelId: channelName),
                    ),
                  )
                else
                  const Center(
                    child: Text(
                      'Waiting for another user to join...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                // Local user's video
                Positioned(
                  top: 20,
                  left: 20,
                  child: SizedBox(
                    width: 120,
                    height: 160,
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(_muted ? Icons.mic_off : Icons.mic),
              color: _muted ? Colors.red : Colors.green,
              onPressed: () async {
                await _engine?.muteLocalAudioStream(!_muted);
                setState(() {
                  _muted = !_muted;
                });
              },
            ),
            IconButton(
              icon: Icon(_videoDisabled ? Icons.videocam_off : Icons.videocam),
              color: _videoDisabled ? Colors.red : Colors.green,
              onPressed: () async {
                await _engine?.muteLocalVideoStream(!_videoDisabled);
                setState(() {
                  _videoDisabled = !_videoDisabled;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.call_end),
              color: Colors.red,
              onPressed: () async {
                await _engine?.leaveChannel();
                setState(() {
                  _joined = false;
                  _remoteUid = null;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';

const String appId = '25b5c1a63fd34fb2afe3bcf7f96d40f9';
const String channelName = 'healthsaathi_channel';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  RtcEngine? _engine;
  int? _remoteUid;
  bool _joined = false;
  bool _muted = false;
  bool _videoDisabled = false;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    // Check permission statuses
    final cameraStatus = await Permission.camera.status;
    final micStatus = await Permission.microphone.status;

    // Request permissions if not granted
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
    if (!micStatus.isGranted) {
      await Permission.microphone.request();
    }

    // Recheck permissions after requesting
    if (!await Permission.camera.isGranted ||
        !await Permission.microphone.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('camera_and_microphone_required'.tr),
          ),
        );
      }
      return;
    }

    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(const RtcEngineContext(appId: appId));

      await _engine!
          .setChannelProfile(ChannelProfileType.channelProfileCommunication);
      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            if (mounted) {
              setState(() => _joined = true);
            }
          },
          onUserJoined: (connection, uid, elapsed) {
            if (mounted) {
              setState(() => _remoteUid = uid);
            }
          },
          onUserOffline: (connection, uid, reason) {
            if (mounted) {
              setState(() => _remoteUid = null);
            }
          },
        ),
      );

      await _engine!.enableVideo();
      await _engine!.startPreview();

      await _engine!.joinChannel(
        token: '', // Replace with a valid token if required
        channelId: channelName,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('error_initializing_agora'
                  .trParams({'error': e.toString()}))),
        );
      }
    }
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('video_call'.tr)),
      body: (_engine == null || !_joined)
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                if (_remoteUid != null)
                  AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _engine!,
                      canvas: VideoCanvas(uid: _remoteUid),
                      connection: RtcConnection(channelId: channelName),
                    ),
                  )
                else
                  Center(
                    child: Text(
                      'waiting_for_user'.tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: SizedBox(
                    width: 120,
                    height: 160,
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(_muted ? Icons.mic_off : Icons.mic),
              color: _muted ? Colors.red : Colors.green,
              tooltip: _muted ? 'unmute'.tr : 'mute'.tr,
              onPressed: () async {
                await _engine?.muteLocalAudioStream(!_muted);
                setState(() {
                  _muted = !_muted;
                });
              },
            ),
            IconButton(
              icon: Icon(_videoDisabled ? Icons.videocam_off : Icons.videocam),
              color: _videoDisabled ? Colors.red : Colors.green,
              tooltip: _videoDisabled ? 'enable_video'.tr : 'disable_video'.tr,
              onPressed: () async {
                await _engine?.muteLocalVideoStream(!_videoDisabled);
                setState(() {
                  _videoDisabled = !_videoDisabled;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.call_end),
              color: Colors.red,
              tooltip: 'end_call'.tr,
              onPressed: () async {
                await _engine?.leaveChannel();
                setState(() {
                  _joined = false;
                  _remoteUid = null;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';

const String appId = 'b7b8ab64a16a4dd2a6293c99ae164d8a';

class VideoCallScreen extends StatefulWidget {
  final String channelName;

  const VideoCallScreen({super.key, required this.channelName});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final RtcEngine _engine;
  int? _remoteUid;
  bool _joined = false;
  bool _muted = false;
  bool _videoDisabled = false;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    try {
      // Request permissions
      await [Permission.camera, Permission.microphone].request();

      if (!await Permission.camera.isGranted ||
          !await Permission.microphone.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('camera_and_microphone_required'.tr)),
          );
        }
        return;
      }

      // Create and initialize
      final engine = createAgoraRtcEngine();
      await engine.initialize(const RtcEngineContext(appId: appId));
      _engine = engine;

      await _engine
          .setChannelProfile(ChannelProfileType.channelProfileCommunication);
      await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            print('Join channel success: ${connection.channelId}');
            if (mounted) setState(() => _joined = true);
          },
          onUserJoined: (connection, uid, elapsed) {
            print('Remote user joined: $uid');
            if (mounted) setState(() => _remoteUid = uid);
          },
          onUserOffline: (connection, uid, reason) {
            print('Remote user offline: $uid');
            if (mounted) setState(() => _remoteUid = null);
          },
        ),
      );

      await _engine.enableVideo();
      await _engine.startPreview();

      await _engine.joinChannel(
        token: '',
        channelId: widget.channelName,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      print('Error initializing Agora: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('error_initializing_agora'
                  .trParams({'error': e.toString()}))),
        );
      }
    }
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('video_call'.tr)),
      body: !_joined
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Remote view
                _remoteUid != null
                    ? AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: _remoteUid),
                          connection:
                              RtcConnection(channelId: widget.channelName),
                        ),
                      )
                    : Center(
                        child: Text(
                          'waiting_for_user'.tr,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                // Local view small window
                Positioned(
                  top: 20,
                  left: 20,
                  child: SizedBox(
                    width: 120,
                    height: 160,
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(_muted ? Icons.mic_off : Icons.mic),
              color: _muted ? Colors.red : Colors.green,
              tooltip: _muted ? 'unmute'.tr : 'mute'.tr,
              onPressed: () async {
                await _engine.muteLocalAudioStream(!_muted);
                setState(() => _muted = !_muted);
              },
            ),
            IconButton(
              icon: Icon(_videoDisabled ? Icons.videocam_off : Icons.videocam),
              color: _videoDisabled ? Colors.red : Colors.green,
              tooltip: _videoDisabled ? 'enable_video'.tr : 'disable_video'.tr,
              onPressed: () async {
                await _engine.muteLocalVideoStream(!_videoDisabled);
                setState(() => _videoDisabled = !_videoDisabled);
              },
            ),
            IconButton(
              icon: const Icon(Icons.call_end),
              color: Colors.red,
              tooltip: 'end_call'.tr,
              onPressed: () async {
                await _engine.leaveChannel();
                setState(() {
                  _joined = false;
                  _remoteUid = null;
                });
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';

const String appId = 'b7b8ab64a16a4dd2a6293c99ae164d8a';

class VideoCallScreen extends StatefulWidget {
  final String channelName;

  const VideoCallScreen({super.key, required this.channelName});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  RtcEngine? _engine; // Made nullable to avoid late error
  int? _remoteUid;
  bool _joined = false;
  bool _muted = false;
  bool _videoDisabled = false;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    try {
      // Request permissions
      await [Permission.camera, Permission.microphone].request();

      if (!await Permission.camera.isGranted ||
          !await Permission.microphone.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('camera_and_microphone_required'.tr)),
          );
        }
        return;
      }

      // Create and initialize
      final engine = createAgoraRtcEngine();
      await engine.initialize(const RtcEngineContext(appId: appId));
      _engine = engine;

      await _engine
          ?.setChannelProfile(ChannelProfileType.channelProfileCommunication);
      await _engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      _engine?.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            print('Join channel success: ${connection.channelId}');
            if (mounted) setState(() => _joined = true);
          },
          onUserJoined: (connection, uid, elapsed) {
            print('Remote user joined: $uid');
            if (mounted) setState(() => _remoteUid = uid);
          },
          onUserOffline: (connection, uid, reason) {
            print('Remote user offline: $uid');
            if (mounted) setState(() => _remoteUid = null);
          },
        ),
      );

      await _engine?.enableVideo();
      await _engine?.startPreview();

      await _engine?.joinChannel(
        token: '',
        channelId: widget.channelName,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      print('Error initializing Agora: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('error_initializing_agora'
                  .trParams({'error': e.toString()}))),
        );
      }
    }
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('video_call'.tr)),
      body: !_joined || _engine == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Remote view
                _remoteUid != null
                    ? AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: _engine!,
                          canvas: VideoCanvas(uid: _remoteUid),
                          connection:
                              RtcConnection(channelId: widget.channelName),
                        ),
                      )
                    : Center(
                        child: Text(
                          'waiting_for_user'.tr,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                // Local view small window
                Positioned(
                  top: 20,
                  left: 20,
                  child: SizedBox(
                    width: 120,
                    height: 160,
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(_muted ? Icons.mic_off : Icons.mic),
              color: _muted ? Colors.red : Colors.green,
              tooltip: _muted ? 'unmute'.tr : 'mute'.tr,
              onPressed: () async {
                await _engine?.muteLocalAudioStream(!_muted);
                setState(() => _muted = !_muted);
              },
            ),
            IconButton(
              icon: Icon(_videoDisabled ? Icons.videocam_off : Icons.videocam),
              color: _videoDisabled ? Colors.red : Colors.green,
              tooltip: _videoDisabled ? 'enable_video'.tr : 'disable_video'.tr,
              onPressed: () async {
                await _engine?.muteLocalVideoStream(!_videoDisabled);
                setState(() => _videoDisabled = !_videoDisabled);
              },
            ),
            IconButton(
              icon: const Icon(Icons.call_end),
              color: Colors.red,
              tooltip: 'end_call'.tr,
              onPressed: () async {
                await _engine?.leaveChannel();
                setState(() {
                  _joined = false;
                  _remoteUid = null;
                });
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
