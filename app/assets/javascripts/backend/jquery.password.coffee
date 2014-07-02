$.extend
  password: (length, special)->
    iteration = 0
    password = ''
    while iteration < length
      randomNumber = (Math.floor((Math.random() * 100)) % 94) + 33
      continue if (randomNumber >=33) && (randomNumber <=47)
      continue if (randomNumber >=58) && (randomNumber <=64)
      continue if (randomNumber >=91) && (randomNumber <=96)
      continue if (randomNumber >=123) && (randomNumber <=126)
      iteration++
      password += String.fromCharCode(randomNumber)
    password