import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:triviaapp/models/trivia_question.dart';

class RoomService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const int maxPlayers = 4;

  Future<String> createRoom({
    required String hostUid,
    required String hostName,
    required List<TriviaQuestion> questions,
    required String difficulty,
    required String topic,
  }) async {
    final roomRef = _db.collection('rooms').doc();

    final List<Map<String, dynamic>> mappedQuestions =
        questions.map((q) => q.toMap()).toList();

    final roomData = {
      'host': hostUid,
      'hostName': hostName,
      'topic': topic,
      'difficulty': difficulty,
      'roomCode': roomRef.id.substring(0, 6),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'started': false,
      'ended': false,
      'players': [
        {'uid': hostUid, 'name': hostName, 'score': 0},
      ],
      'questions': mappedQuestions,
      'rank': [],
    };

    await roomRef.set(roomData);
    return roomRef.id;
  }

  // Unirse a sala por código: ahora valida started y máximo players
  Future<bool> joinRoom({
    required String roomCode,
    required String uid,
    required String name,
  }) async {
    final query = await _db
        .collection('rooms')
        .where('roomCode', isEqualTo: roomCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return false;

    final doc = query.docs.first;
    final data = doc.data();
    final roomRef = doc.reference;

    // Si partida ya empezó, no permitir unirse
    if (data['started'] == true) return false;

    final players = List<Map<String, dynamic>>.from(data['players'] ?? []);

    // Limitar número de jugadores
    if (players.length >= maxPlayers) return false;

    // Si ya está el jugador, retornar true (idempotente)
    if (players.any((p) => p['uid'] == uid)) return true;

    await roomRef.update({
      'players': FieldValue.arrayUnion([
        {'uid': uid, 'name': name, 'score': 0},
      ]),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return true;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> listenRoom(String roomId) {
    return _db.collection('rooms').doc(roomId).snapshots();
  }

  // Solo el host puede iniciar
  Future<bool> startGame({
    required String roomId,
    required String uid,
  }) async {
    final ref = _db.collection('rooms').doc(roomId);
    final snap = await ref.get();
    if (!snap.exists) return false;
    final data = snap.data()!;
    final host = data['host'];

    if (host != uid) {
      return false;
    }

    await ref.update({
      'started': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return true;
  }

  Future<void> updateScore({
    required String roomId,
    required String uid,
    required int score,
  }) async {
    final ref = _db.collection('rooms').doc(roomId);
    final snap = await ref.get();
    final players = List<Map<String, dynamic>>.from(snap['players'] ?? []);

    final index = players.indexWhere((p) => p['uid'] == uid);
    if (index >= 0) {
      players[index]['score'] = score;
      await ref.update({
        'players': players,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Guarda ranking final y marca como ended
  Future<void> finishGame(String roomId) async {
    final ref = _db.collection('rooms').doc(roomId);
    final snap = await ref.get();
    if (!snap.exists) return;
    final players = List<Map<String, dynamic>>.from(snap['players'] ?? []);

    players.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

    await ref.update({
      'ended': true,
      'rank': players,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Limpieza manual: borrar salas inactivas (te sirve para probar)
  Future<void> cleanupInactiveRooms({required Duration olderThan}) async {
    final cutoff = DateTime.now().subtract(olderThan);
    final q = await _db
        .collection('rooms')
        .where('updatedAt', isLessThan: Timestamp.fromDate(cutoff))
        .get();

    for (final doc in q.docs) {
      await doc.reference.delete();
    }
  }
}


