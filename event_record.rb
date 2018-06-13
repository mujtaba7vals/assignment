require 'date'
require_relative 'event_details'
class EventRecord
  @@events_date = {}
  @@events_details = {}
  @@id = 0
  def add_event_details(name, date)
    begin
      date = date.strip.split("-")
      date = DateTime.new(date[0].to_i, date[1].to_i, date[2].to_i)
      @@id += 1
      @@events_details[@@id] = Event_Details.new(@@id, name, date)
      key = date.year.to_s + "-" + date.month.to_s
      day = date.day
      if @@events_date.has_key? (key)
        @@events_date[key].push([name, day])
      else
        @@events_date[key] = Array.new
        @@events_date[key].push([name, day])
      end
      print "Event added\n"
      rescue
        puts "Incorrect Data"
    end
  end
  
  def self.return_all_events
    if @@events_details.length == 0
      puts "No event added yet"
    else
      @@events_details.each do |key, event_detail|
        puts "ID: #{event_detail.id} Name: #{event_detail.name} Date: #{event_detail.date.year}-#{event_detail.date.month}-#{event_detail.date.day} "
    end
    end
  end
  
  def self.add_event
    EventRecord.new
  end
  
  def self.events_for_given_month
    if @@events_details.length == 0
      puts "No event added yet"
    else
      begin
        print "Enter the required year (yyyy)\n"
        year = gets.strip.to_i
        print "Enter the required month (mm)\n"
        month = gets.strip.to_i
        date = DateTime.new(year, month)
        key = date.year.to_s + "-" + date.month.to_s
        if [1, 3, 5, 7, 8, 10, 12].include?(date.month)
          range = (1..31)
        elsif [4, 6, 9, 11].include?(date.month)
          range = (1..30)
        else
          range = (1..28)
        end
        temp_event_detail_hash = Hash.new{ |h, k| h[k] = [] }
        if @@events_date.has_key? (key)
          @@events_date[key].each do |n|
            temp_event_detail_hash[n[1].to_i] << n[0]
          end
          temp_event_detail_hash = temp_event_detail_hash.sort.to_h
          print_counter = 0
          range.each do |x|
            if temp_event_detail_hash.has_key? (x)
              print "#{x}: #{temp_event_detail_hash[x]} "
              print_counter += 1
            else
              print "#{x} \t"
              print_counter += 1
            end
            if print_counter == 4
              print_counter = 0
              puts 
            end
          end
        else
          puts "No Events Found"
        end
      rescue 
        puts "Incorrect Data"
      end
    end
  end

   def self.events_for_given_date
    if @@events_details.length == 0
      puts "No event added yet"
    else
      begin
        print "Enter the required date (yyyy-mm-dd)\n"
        date = gets.strip.split("-")
        date = DateTime.new(date[0].to_i, date[1].to_i, date[2].to_i)
        key = date.year.to_s + "-" + date.month.to_s
        temp_event_detail_hash = Hash.new{ |h, k| h[k] = [] }
        if @@events_date.has_key? (key)
          @@events_date[key].each do |n|
            temp_event_detail_hash[n[1].to_i] << n[0]
          end
          temp_event_detail_hash = temp_event_detail_hash.sort.to_h
          temp_event_detail_hash.each do |x|
            if temp_event_detail_hash.has_key? (date.day)
              print " Event(s) Scheduled: #{temp_event_detail_hash[date.day]} \t"
            else
              puts "No Events Found"  
            end
          end
        else
          puts "No Events Found"
        end
      rescue 
        puts "Incorrect Data"
      end
    end
  end
  
  def self.delete_event
    if @@events_details.length == 0
      puts "No event added yet"
    else
      print "Enter an Id from the list of events given below\n"
      self.return_all_events
      begin
        id_entered = gets.strip.to_i 
        if @@events_details.has_key?(id_entered)
          year = @@events_details[id_entered].date.year
          month = @@events_details[id_entered].date.month
          day = @@events_details[id_entered].date.day
          name = @@events_details[id_entered].name
          key = year.to_s + "-" + month.to_s
          temp_event_detail_array = @@events_date[key]
          for i in (0...temp_event_detail_array.length)
            if temp_event_detail_array[i][1] == day && temp_event_detail_array[i][0] == name 
              temp_event_detail_array[i..i] = []
              @@events_details.delete(id_entered)
              @@events_date[key] = temp_event_detail_array
              puts "Event Deleted"
              break
            end
          end
                  ##does not function##
          # @@events_date[key].each do |element| 
          #   if element[1] == day && element[0] == name 
          #     @@events_date[key].delete(element)
          #     @@events_details.delete(id_entered)
          #     puts "Event Deleted"
          #   end
          # end
        else
          puts "Event not found"
        end
      rescue 
        puts "Incorrect data"
      end
    end
  end
end
