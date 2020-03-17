import tweepy



access_token =       "30951060-DNMk0Fjrgf7XoTw956gpgwtHO04rRyuI1VMkJfWHF"
access_token_secret = "iwimJbbp1DEuZ8QbiJE0z3Sbsf0xH7JptFrxMWpq7Xzra"
consumer_key =         "51GtjuDVFbGgpLKbppH4M8Uv4"
consumer_secret =      "V67ug41vUT5vRTOT7eCrIl8fsvcIB46IGoYOt5YQ71y0ANGHPg"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

public_tweets = api.home_timeline()
i=0
print("LINEA DE TIEMPO")
for tweet in public_tweets:
    i=i+1
    print(i ," : " ,tweet.text)

print("Datos de mfcortes")
user= api.get_user('AlbertoMayol')

print("screen name ",user.screen_name)
print("Seguidores ",user.followers_count)

for friend in user.friends():
    print(friend.screen_name, " : ", friend.followers_count)
