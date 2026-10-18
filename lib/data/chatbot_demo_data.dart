const crisisKeywords = [
  'bunuh diri',
  'menyakiti diri',
  'mengakhiri hidup',
  'tidak ingin hidup',
];

const crisisReply =
    'Aku turut prihatin kamu merasa seperti ini. Kamu tidak sendirian. '
    'Tolong segera hubungi orang terdekat atau layanan darurat setempat. '
    'Kamu juga bisa menghubungi psikolog atau psikiater untuk bantuan langsung.';

const demoReplies = <String, String>{
  'napas': 'Coba teknik napas 4-4-4-4: tarik napas 4 hitungan, tahan 4, '
      'hembuskan 4, tahan 4. Ulangi beberapa putaran. Detail ada di menu Edukasi.',
  'panik': 'Serangan panik biasanya mereda dalam beberapa menit. Duduk di '
      'tempat aman, atur napas pelan, dan hubungi orang terdekat bila perlu.',
  'grounding': 'Coba grounding 5-4-3-2-1: sebutkan 5 hal yang kamu lihat, '
      '4 yang kamu sentuh, 3 yang kamu dengar, 2 yang kamu cium, 1 yang kamu rasakan.',
  'cemas': 'Rasa cemas itu valid. Coba tarik napas pelan dan fokus pada '
      'sekitarmu. Kalau terus mengganggu, pertimbangkan bicara dengan profesional.',
  'profesional': 'Pertimbangkan menemui psikolog atau psikiater bila kecemasan '
      'berlangsung lama, sering kambuh, atau mengganggu aktivitas harian.',
};

const defaultReply =
    'Maaf, aku belum paham pertanyaan itu. Coba tanyakan seputar napas, '
    'panik, grounding, cemas, atau kapan ke profesional.';

String getDemoReply(String message) {
  final text = message.toLowerCase();
  for (final k in crisisKeywords) {
    if (text.contains(k)) return crisisReply;
  }
  for (final entry in demoReplies.entries) {
    if (text.contains(entry.key)) return entry.value;
  }
  return defaultReply;
}