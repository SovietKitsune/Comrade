import Event from require 'comrade'

class messageCreate extends Event -- Class name should be the event name
  execute: (msg) => -- No need for super, arguments are the event arguments
    p msg

messageCreate!