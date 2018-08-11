//
//  Globals.h
//  ESR
//
//  Created by Aecor Digital on 19/06/17.
//  Copyright © 2017 Aecor Digital. All rights reserved.
//

#ifndef Globals_h
#define Globals_h
#define BaseURL @"http://steezle.ca/wp-json/"
//#define BaseURL @"http://mytestwork.com/steezle/wp-json/"

#define Registration @"rest/register"
#define Login @"rest/login"
#define SocialLogin @"rest/social-login"
#define CheckApi @"/api/auth/check"
#define Categories @"rest/get_categories"
#define Sub_categories @"rest/get_subcategories"
#define ProductList @"rest/productlist"
#define ProductShuffel @"rest/shuffle"
#define ProductSubDetails @"rest/product-detail"
#define TournamentSummary @"/api/tournaments/tournamentSummary"
#define Forgotpassword @"rest/forgot_password"
#define Resetpassword @"/api/password/reset"
#define UpdateProfile @"/api/user/update/"
#define MakeTournamentFavourite @"/api/users/setFavourite"
#define RemoveTournamentFavourite @"/api/users/removeFavourite"
#define SetTournamentDefault @"/api/users/setDefaultFavourite"
#define GetTournamentDefault @"/api/users/getLoginUserDefaultTournament"
#define GetUserFavouriteTournamentList @"/api/users/getLoginUserFavouriteTournament"
#define GetTournamentAge @"/api/age_group/getCompetationFormat"
#define GetTournamentGroups @"/api/match/getDraws"

#define GetTournamentClub @"/api/tournaments/getTournamentClub"
#define GetClubTeam @"/api/teams/getTeamsList"
#define GetAgeTeam @"/api/teams/getTeamsList"
#define GetGroupTeam @"/api/teams/getTeamsList"

#define  GetDrawTable @"/api/match/getDrawTable"
#define GetStanding @"/api/match/getStanding"
#define GetMatchFixtures @"/api/match/getFixtures"
#define GetMatchFixturesTeamID @"/api/match/getFixtures"
#define GetMatchFixturesClubID @"/api/match/getFixtures"
#define GetAgeGroup @"/api/match/getDraws"

#define UpdateProfileImage @"/api/users/updateProfileImage"
#define GetSetting @"/api/users/getSetting"
#define PostSetting @"/api/users/postSetting"
#define PushNotification @"/api/users/updatefcm"


#define Search @"rest/search"

#define GetFavorite @"rest/get-favlist"
#define AddFavorite @"rest/add-favlist"
#define RemoveFavorite @"rest/remove-favlist"

#define GetCart @"rest/get-cart"
#define AddCart @"rest/add-cart"
#define RemoveCart @"rest/remove-cart"
#define CheckVariatons @"rest/variation-check"

#define GetCountry @"rest/get-countries"
#define GetState @"rest/get-state"

#define GetAddress @"rest/get-address"
#define SetAddress @"rest/set-address"

#define GetShippingAddress @"rest/get-shipping-address"
#define SetShippingAddress @"rest/set-shipping-address"
#define EditProfile @"rest/editprofile"

#define Measurment @"rest/set-measurment"
#define LOGOUT @"rest/logout"
#define Checkout @"rest/checkout"
#define PaymentConfirmStripe @"rest/payment"
#define Save_Card @"rest/save-card"
#define OrderHistory @"rest/order-history"
#define OrderCencelled @"rest/cancel-order"
#define OrderDetail @"rest/order-detail"
#define Filter_Product @"rest/product-filters"
#define Filter_Apply @"rest/apply-filters"
#define Coupon_Code @"rest/apply-coupon"
#define GetSaveCard @"rest/get-saved-card"
#define RemoveSaveCard @"rest/delete-saved-card"
#define Coupon_code_delete @"rest/remove-coupon"
//#define AddCart @"rest/add-cart"
//#define RemoveCart @"rest/remove-cart"
//#define GetCart @"rest/get-cart"

#endif /* Globals_h */

