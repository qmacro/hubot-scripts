# Basecamp todos
# Set the HUBOT_BASECAMP_KEY and HUBOT_BASECAMP_URL
#
# my todos - Get a count of your outstanding todo items by list

bcapi = require 'bcapi'

module.exports = (robot) ->
  robot.hear /my todo(s| items)/i, (msg) ->
    basecamp_users msg, (people) ->
      msg_from = msg.message.user.email_address.toLowerCase()
      basecamp_id = people[msg_from]
      if basecamp_id?
        msg.send "Your outstanding todo items, by todo list:"
        bcapi.get "todo_lists.xml?responsible_party=#{basecamp_id}", (data) ->
          for list in data['todo-list']
            msg.send "#{list.name}: #{list['todo-items']['todo-item'].length or 1}"
      else
        msg.send "None: Take the rest of the day off!"



# Return hash of Basecamp users as email:id pairs
basecamp_users = (msg, handler) ->
  bcapi.get 'people.xml', (data) ->
    users = {}
    users[person['email-address'].toLowerCase()] = person['id']['#'] for person in data.person
    handler users

