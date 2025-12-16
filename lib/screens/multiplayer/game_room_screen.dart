import 'package:flutter/material.dart';
import 'package:triviaapp/services/room_service.dart';
import 'package:triviaapp/screens/multiplayer/multiplayer_game_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class GameRoomScreen extends StatelessWidget {
  final String roomId;

  const GameRoomScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Sala de Juego"), centerTitle: true),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: RoomService().listenRoom(roomId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return const Center(
              child: Text(
                "La sala ya no existe.\nPudo haber sido eliminada.",
                textAlign: TextAlign.center,
              ),
            );
          }

          final room = snapshot.data!.data()!;
          final List players = List.from(room['players']);
          final bool started = room['started'] == true;
          final String topic = room['topic'] ?? "General";
          final String difficulty = room['difficulty'] ?? "medio";
          final String hostId = room['host'];

          // Si el juego ya inició, enviamos a la pantalla de juego sincronizada
          if (started) {
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => MultiplayerGameScreen(roomId: roomId),
                ),
              );
            });

            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título código + botones de copiar/compartir
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Código de Sala: ${room['roomCode']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.blue),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: room['roomCode']),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Código copiado al portapapeles"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),

                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.green),
                      onPressed: () {
                        final code = room['roomCode'];
                        Share.share(
                          "Únete a mi sala de Trivia!\nCódigo: $code",
                          subject: "Invitación a sala",
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Información básica de la sala
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue.withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tema: $topic",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Dificultad: ${difficulty.toUpperCase()}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Jugadores en la sala:",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),

                // Lista de jugadores
                Expanded(
                  child: ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (_, index) {
                      final p = players[index];
                      final bool isHost = p['uid'] == hostId;

                      return ListTile(
                        leading: Icon(
                          isHost ? Icons.star : Icons.person,
                          color: isHost ? Colors.orange : Colors.grey,
                        ),
                        title: Text(
                          p['name'] ?? "Sin nombre",
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: isHost ? const Text("Host") : null,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Botón para iniciar partida (solo host)
                if (currentUid == hostId)
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () async {
                        final ok = await RoomService().startGame(
                          roomId: roomId,
                          uid: currentUid,
                        );

                        if (!ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Solo el host puede iniciar la partida.",
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text("Iniciar Partida"),
                    ),
                  )
                else
                  const Center(
                    child: Text(
                      "Esperando al host para iniciar la partida...",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),

                const SizedBox(height: 15),
              ],
            ),
          );
        },
      ),
    );
  }
}
