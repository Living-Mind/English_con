### English_con
import os

text = str(input("Paste text: "))
    
os.system('clear')
print(text)

words_list = []

while True:

    word = str(input("\nWrite unknown word: "))

    if word != "q":

        words_list.append(word)
        #print(words_list)
        print(f'The word "{word}" was added.')
        print('Write "q" to go to next section.')

    else:

        break

os.system('clear')
print("Writing practice\n")

print("Write 3 sentences for each word.")

for word in words_list:
    print(f'\nThe word is {word}')

    sentence = 0

    while True:

        if sentence != 3:

            str(input(f'\nWrite a sentence with the word {word}: \n'))
            sentence += 1

        else:

            break
