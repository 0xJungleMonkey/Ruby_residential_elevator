
class Column
    attr_accessor :column_ID, :column_status, :column_elevatorList, :column_callButtonList, :column_amountOfElevators, :column_amountOfFloors
    def initialize(_id,_amountOfFloors, _amountOfElevators)
        @column_ID= _id
        @column_status = 'Online'
        @column_elevatorList = []
        @column_callButtonList =[]
        @column_amountOfElevators = _amountOfElevators
        @column_amountOfFloors = _amountOfFloors
        self.createCallButtons
        self.createElevators  
    end
    def createCallButtons
        buttonFloor = 1
        callButtonID = 1
        while buttonFloor < self.column_amountOfFloors+1 do
            # puts _amountOfFloors
            if buttonFloor <  self.column_amountOfFloors
                callButton = CallButton.new(callButtonID, buttonFloor, 'up')
                # puts callButtonID
                self.column_callButtonList.append(callButton)
                callButtonID += 1
            end
            if buttonFloor > 1
                callButton = CallButton.new(callButtonID, buttonFloor, 'down')
                self.column_callButtonList.append(callButton)
                # puts callButtonID
                callButtonID += 1
                
            end
            buttonFloor += 1
        end    
        return self.column_callButtonList
    end
    def createElevators
        elevatorID = 1
        while elevatorID < self.column_amountOfElevators+1
            elevator = Elevator.new(elevatorID, self.column_amountOfFloors)
            self.column_elevatorList.append(elevator)
            elevatorID += 1 
        end
        # puts self.column_elevatorList.length
        return self.column_elevatorList
        
        # end
    # puts self.column_elevatorList.length
    end
    def requestElevator(floor,direction)
        best = findElevator(floor,direction)
        bestList =best.elevator_floorRequestList
        bestList.append(floor)
        best.move
        #  elevator.operateDoors()
        # puts best.elevator_status
    
        return best
    end 
    def findElevator(requestedFloor, requestedDirection)
        bestElevator = {}
        bestScore = 5
        referenceGap = 10000000
        bestElevatorInformations = []
        self.column_elevatorList.each do |elevator|
            # The elevator is at my floor and going in the direction I want
            if (requestedFloor == elevator.elevator_currentFloor) & (elevator.elevator_status == 'stopped') &(requestedDirection == elevator.elevator_direction)
                bestElevatorInformations = checkIfElevatorIsBetter(1, elevator, bestScore, referenceGap, bestElevator,requestedFloor)
                # puts "if1"
            # The elevator is lower than me, is coming 'Up' and I want to go 'Up'
            elsif (requestedFloor > elevator.elevator_currentFloor) & (elevator.elevator_direction == 'up') &(requestedDirection == elevator.elevator_direction)
                bestElevatorInformations = checkIfElevatorIsBetter(2, elevator,bestScore, referenceGap, bestElevator, requestedFloor)
                # puts "el2"
            # The elevator is higher than me, is coming 'Down' and I want to go 'Down'
            elsif (requestedFloor < elevator.elevator_currentFloor) & (elevator.elevator_direction == 'down') &(requestedDirection == elevator.elevator_direction)
                bestElevatorInformations = checkIfElevatorIsBetter(2, elevator,bestScore, referenceGap, bestElevator, requestedFloor)
                # puts "el3"
            # The elevator is idle
            elsif elevator.elevator_status == 'idle'
                bestElevatorInformations = checkIfElevatorIsBetter(3, elevator,bestScore, referenceGap, bestElevator, requestedFloor)
                # puts "el4"
            else
                bestElevatorInformations = checkIfElevatorIsBetter(4, elevator, bestScore, referenceGap, bestElevator, requestedFloor)
                # puts "el5"
            end
            bestElevator = bestElevatorInformations[0]
            bestScore = bestElevatorInformations[1]
            referenceGap = bestElevatorInformations[2]
        # puts self.column_elevatorList[1].elevator_ID
        
        end
        return bestElevator
    end
    def checkIfElevatorIsBetter(scoreToCheck, newElevator, bestScore, referenceGap, bestElevator, floor)
        if scoreToCheck < bestScore
             bestScore= scoreToCheck
             bestElevator = newElevator
             referenceGap = (newElevator.elevator_currentFloor - floor).abs()
        
        elsif bestScore == scoreToCheck
            gap = (newElevator.elevator_currentFloor - floor).abs()
            if referenceGap > gap
                 bestElevator = newElevator
                 referenceGap = gap
            end
        end    
        
        return [bestElevator, bestScore, referenceGap]
    
    end
end
class FloorRequestButton
    attr_accessor :floorrequestbutton_ID, :floorrequestbutton_status, :floorrequestbutton_floor
    @@no_of_floorrequestbutton = 0
    def initialize(_id, _floor)
        @floorrequestbutton_ID= _id
        @floorrequestbutton_status = 'OFF'
        @floorrequestbutton_floor = _floor
    end    
end 
class Elevator 
    attr_accessor :elevator_ID, :elevator_status, :elevator_currentFloor, :elevator_door, :elevator_floorRequestButtonList, :elevator_floorButtonsList, :elevator_floorRequestList, :elevator_amountOfFloors, :elevator_direction
    @@no_of_elevator = 0
    def initialize(_id, _amountOfFloors)
        @elevator_ID= _id
        @elevator_status = 'idle'
        @elevator_currentFloor = 1
        @elevator_direction = nil
        @elevator_door = Door.new(_id)
        @elevator_floorRequestButtonList =[]
        @elevator_floorButtonsList =[]
        @elevator_floorRequestList = []
        @elevator_amountOfFloors = _amountOfFloors
        self.createFloorRequestButtons
    end        
    def createFloorRequestButtons
        buttonFloor = 1
        buttonID = 1
            until buttonID  == @elevator_amountOfFloors+1 do 
                floorRequestButton = FloorRequestButton.new(buttonID, buttonFloor)
                @elevator_floorRequestButtonList.append(floorRequestButton)
                buttonFloor += 1
                buttonID += 1
        end
        return @elevator_floorRequestButtonList
    end

    # Simulate when a user press a button inside the elevator
    def requestFloor(floor)
        @elevator_floorRequestList.append(floor)
        self.move
        #  operateDoors()
        # puts elevator_ID, elevator_currentFloor, elevator_status
        return self
    end    
    def move
        while @elevator_floorRequestList.length != 0 
            destination = @elevator_floorRequestList[0]
            # puts destination
            # puts @elevator_currentFloor
            @elevator_status = 'moving'
            # puts elevator_status
            if @elevator_currentFloor < destination
                @elevator_direction = 'up'
                sortFloorList
                while @elevator_currentFloor < destination
                    @elevator_currentFloor += 1
                    # @elevator_screenDisplay = @elevator_currentFloor
                end
            elsif @elevator_currentFloor > destination
                @elevator_direction = 'down'
                sortFloorList()
                while @elevator_currentFloor > destination
                    @elevator_currentFloor -= 1
                    # @elevator_screenDisplay = @elevator_currentFloor
                end
            end 
            # puts elevator_direction
            @elevator_status = 'stopped'
            @elevator_floorRequestList.shift
            # puts  @elevator_floorRequestList[0]
        end
        @elevator_status = 'idle'
    end
    def sortFloorList
        if @elevator_direction == 'up'
            @elevator_floorRequestList.sort()
        else
            @elevator_floorRequestList.reverse()
        end
    end
end
class CallButton
    attr_accessor :callbutton_ID, :callbutton_status, :callbutton_floor, :callbutton_direction
    @@no_of_callbutton = 0
    def initialize(_id, _floor, _direction)
        @callbutton_ID= _id
        @callbutton_status = "OFF"
        @callbutton_floor = _floor
        @callbutton_direction = _direction
    end    
end
class Door
    attr_accessor :door_ID, :door_status
    @@no_of_door = 0
    def initialize(_id)
        @door_ID= _id
        @door_status = 'closed'
    end    
end
class TestProcess
    attr_accessor :selectedElevator, :pickedUpUser
    @@no_of_TestProcess = 0
    def initialize(column, requestedFloor, direction, destination)
        @selectedElevator = column.requestElevator(requestedFloor, direction)
        @pickedUpUser = FALSE
        if selectedElevator.elevator_currentFloor == requestedFloor
            @pickedUpUser = TRUE
        end
        selectedElevator.requestFloor(destination)
        moveAllElevators(column)
      
        column.column_elevatorList.each do |elevator| 
            if elevator.elevator_ID == selectedElevator.elevator_ID
                elevator.elevator_currentFloor = selectedElevator.elevator_currentFloor
            end
        end
    end


    def moveAllElevators(column)
        column.column_elevatorList.each do |elevator|
            if elevator.elevator_floorRequestList.length != 0
                elevator.move
            end
        end
    end
end