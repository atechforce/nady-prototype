[1mdiff --git a/lib/screens/dashboard_screen.dart b/lib/screens/dashboard_screen.dart[m
[1mindex c115bd3..ba4a247 100644[m
[1m--- a/lib/screens/dashboard_screen.dart[m
[1m+++ b/lib/screens/dashboard_screen.dart[m
[36m@@ -3,10 +3,14 @@[m [mimport '../widgets/feature_card.dart';[m
 import 'chatbot_screen.dart';[m
 import 'contacts_screen.dart';[m
 import 'education_screen.dart';[m
[31m-import 'fcm_test_screen.dart';[m
 import 'monitoring_screen.dart';[m
[32m+[m[32mimport 'fcm_test_screen.dart';[m
[32m+[m[32m<<<<<<< HEAD[m
 import 'profile_screen.dart';[m
 import 'role_selection_screen.dart';[m
[32m+[m[32m=======[m
[32m+[m[32mimport 'fcm_test_screen.dart';[m
[32m+[m[32m>>>>>>> fcm-experiment[m
 [m
 class DashboardScreen extends StatelessWidget {[m
   const DashboardScreen({super.key});[m
[36m@@ -35,17 +39,20 @@[m [mclass DashboardScreen extends StatelessWidget {[m
         backgroundColor: Colors.transparent,[m
         actions: [[m
           IconButton([m
[31m-            tooltip: 'Uji notifikasi',[m
[31m-            icon: const Icon(Icons.notifications_active_outlined),[m
[31m-            onPressed: () => _go(context, const FcmTestScreen()),[m
[31m-          ),[m
[31m-          IconButton([m
[32m+[m[32m<<<<<<< HEAD[m
             tooltip: 'Keluar',[m
             icon: const Icon(Icons.logout),[m
             onPressed: () => logoutToRoleSelection(context),[m
           ),[m
         ],[m
       ),[m
[32m+[m[32m=======[m
[32m+[m[32m            icon: const Icon(Icons.notifications_active_outlined),[m
[32m+[m[32m            onPressed: () => _go(context, const FcmTestScreen()),[m
[32m+[m[32m    ),[m
[32m+[m[32m  ],[m
[32m+[m[32m),[m
[32m+[m[32m>>>>>>> fcm-experiment[m
       body: Padding([m
         padding: const EdgeInsets.all(16),[m
         child: Column([m
