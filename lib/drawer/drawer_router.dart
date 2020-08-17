import 'package:else_admin_two/deals/deal_list.dart';
import 'package:else_admin_two/event/AllEventScreen.dart';
import 'package:else_admin_two/feedback/feedback_list.dart';
import 'package:else_admin_two/requests/request_page.dart';
import 'package:else_admin_two/shop/shop_screen.dart';
import 'package:flutter/material.dart';

class DrawerRoute {
  Future routeToProfileOptions(BuildContext context, int index){
    Navigator.pop(context);
    switch (index) {
      case 0 :
        return Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => AllEventScreen(),
          ),
        );
        break;

      case 1 :
        return Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => ShopScreen(),
          ),
        );
        break;

      case 2 :
        return Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => DealSection(),
          ),
        );
        break;

      case 3:
        return Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => FeedBackList(),
          ),
        );
        break;

      case 4:
        return Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => RequestPage(),
          ),
        );
        break;

      default:
        break;
    }
  }
}