require 'twitter'
require 'dotenv'

# On renseigne les clés d'APIs pour se connecter
def client
    Twitter::REST::Client.new do |config|
        config.consumer_key        = CONSUMER_KEY
        config.consumer_secret     = CONSUMER_SECRET
        config.access_token        = ACCESS_TOKEN
        config.access_token_secret = ACCESS_TOKEN_SECRET
    end
end

# On créer une fonction permettant de récuperer les emails sur twitter
# Cette fonction va devoir :
# 1- Chercher les tweets contenant des mots clés : "email", "@" et "antananarivo" en excluant les RT
# 2- Identifier et isoler les tweets contenant un véritable e-mail
# 3- Le stocker dans un tableau

    SEARCH_TERMS = "\@ -RT email"

    search = client.search(SEARCH_TERMS, result_type: "recent").take(200)

    REGEX_EMAIL = /\w+\.?\+?\w+?@\w+\-?\w+\.\w+/

    emails = []
    search.each do |tweet|
        email_matches = "#{tweet.text}".match(REGEX_EMAIL)
        if email_matches
            emails << email_matches.to_s
        end
    end

# Sauvegarder les emails dans un fichier txt
def save_emails
    emails.each do |email|
        # On enregistre les e-mails dans le fichier tweets_email_antananarivo.txt
        File.open("tweets_email_antananarivo.txt", 'a'){|file| file.write(email + "\n")}
    end
end

save_emails