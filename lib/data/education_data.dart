import 'package:flutter/material.dart';
import '../models/education_material.dart';

const educationMaterials = [
  EducationMaterial(
    title: 'Teknik Napas 4-4-4-4',
    category: 'Teknik napas',
    summary: 'Napas teratur untuk menenangkan diri.',
    icon: Icons.air,
    content: 'Teknik ini membantu memperlambat napas saat cemas.\n\n'
        '1. Tarik napas lewat hidung selama 4 hitungan.\n'
        '2. Tahan napas selama 4 hitungan.\n'
        '3. Hembuskan perlahan lewat mulut selama 4 hitungan.\n'
        '4. Tahan 4 hitungan sebelum mengulang.\n\n'
        'Ulangi 4 sampai 6 putaran. Jika pusing, kembali bernapas normal.',
  ),
  EducationMaterial(
    title: 'Grounding 5-4-3-2-1',
    category: 'Grounding',
    summary: 'Kembali ke saat ini lewat lima indra.',
    icon: Icons.spa,
    content: 'Grounding mengalihkan perhatian dari pikiran cemas ke sekitar.\n\n'
        'Sebutkan dalam hati atau dengan suara pelan:\n'
        '• 5 hal yang kamu lihat\n'
        '• 4 hal yang kamu sentuh\n'
        '• 3 hal yang kamu dengar\n'
        '• 2 hal yang kamu cium\n'
        '• 1 hal yang kamu rasakan di mulut\n\n'
        'Lakukan perlahan, tidak perlu terburu-buru.',
  ),
  EducationMaterial(
    title: 'Mengenali Serangan Panik',
    category: 'Pengenalan gejala',
    summary: 'Tanda umum dan hal yang bisa dilakukan.',
    icon: Icons.psychology,
    content: 'Serangan panik bisa berupa jantung berdebar, napas pendek, '
        'gemetar, berkeringat, atau rasa takut yang kuat.\n\n'
        'Yang bisa dilakukan:\n'
        '• Ingat bahwa gejala ini biasanya mereda dalam beberapa menit.\n'
        '• Duduk di tempat yang aman dan atur napas.\n'
        '• Hubungi orang terdekat bila perlu.',
  ),
  EducationMaterial(
    title: 'Kapan Harus ke Profesional',
    category: 'Bantuan profesional',
    summary: 'Tanda bahwa kamu perlu bantuan ahli.',
    icon: Icons.local_hospital,
    content: 'Pertimbangkan menemui psikolog atau psikiater jika:\n'
        '• Kecemasan berlangsung lama dan mengganggu aktivitas.\n'
        '• Serangan panik sering berulang.\n'
        '• Muncul pikiran untuk menyakiti diri sendiri.\n\n'
        'Jika kamu dalam situasi darurat, segera hubungi layanan darurat '
        'setempat atau orang terdekat.',
  ),
  EducationMaterial(
    title: 'Cara Mendampingi Orang Cemas',
    category: 'Untuk orang terdekat',
    summary: 'Tips bagi keluarga dan teman.',
    icon: Icons.favorite,
    content: 'Jika orang terdekatmu sedang cemas:\n'
        '• Tetap tenang dan temani dia.\n'
        '• Dengarkan tanpa menghakimi.\n'
        '• Ajak bernapas pelan bersama.\n'
        '• Hindari kalimat seperti "cuma perasaanmu saja".\n'
        '• Tawarkan bantuan mencari profesional bila perlu.',
  ),
];