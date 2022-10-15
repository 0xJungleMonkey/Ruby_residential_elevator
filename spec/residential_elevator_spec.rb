require 'residential_elevator_controller'
column1 = Column.new(1, 10, 2)
elevator = Elevator.new(1, 10)
callbutton = CallButton.new(1, 1,'up')
floorRequestButton = FloorRequestButton.new(1, 1)
door = Door.new(1)
column2 = Column.new(1, 10, 2)
column3 = Column.new(1, 10, 2)
column4 = Column.new(1, 10, 2)
# results = {0 => "column", 1 => "column", 2 => "column"}
RSpec.describe Column do
    # context "with no strikes or spares" do 
    it "test_Instantiates_a_Column_with_valid_attributes" do
        expect(column1.class).to be Column
        expect(column1.column_ID).to eq 1
        expect(column1.column_status).to eq 'Online'
        expect(column1.column_elevatorList.length).to eq 2
        expect(column1.column_elevatorList[0].class).to be Elevator
        expect(column1.column_callButtonList.length).to eq 18
        expect(column1.column_callButtonList[0].class).to be CallButton
    end
end 

RSpec.describe Column, "#requestElevator"  do
    it "test_Has_a_requestElevator_method" do
        expect(column1.requestElevator(1, "up")).not_to be(nil)
    end
end

RSpec.describe Column, "#requestElevator"  do
    it "test_Can_find_and_return_an_elevator" do
        elevator = column1.requestElevator(1, "up")
        expect(column1.requestElevator(1, "up").class).to be Elevator
    end
end

RSpec.describe Elevator do 
    it "test_Instantiates_a_Elevator_with_valid_attributes" do 
            expect(elevator.class).to be Elevator
            expect(elevator.elevator_ID).to eq 1
            expect(elevator.elevator_status).not_to be(nil)
            expect(elevator.elevator_currentFloor).not_to be(nil)
            expect(elevator.elevator_door.class).to be Door
            expect(elevator.elevator_floorRequestButtonList.length).to eq 10
    end
end
RSpec.describe Elevator, "#requestFloor"  do 
    it "test_Has_a_requestFloor_method" do 
        expect(elevator.requestFloor(1)).not_to be(nil)
    end
end

RSpec.describe CallButton do 
    it "test_Instantiates_a_CallButton_with_valid_attributes" do 
            expect(callbutton.class).to be CallButton
            expect(callbutton.callbutton_ID).to eq 1
            expect(callbutton.callbutton_status).not_to be(nil)
            expect(callbutton.callbutton_floor).to eq 1
            expect(callbutton.callbutton_direction).to eq 'up'
    end
end

RSpec.describe FloorRequestButton do 
    it "test_Instantiates_a_FloorRequestButton_with_valid_attributes" do 
            expect(floorRequestButton.class).to be FloorRequestButton
            expect(floorRequestButton.floorrequestbutton_ID).to eq 1
            expect(floorRequestButton.floorrequestbutton_status).not_to be(nil)
            expect(floorRequestButton.floorrequestbutton_floor).to eq 1
    end
end

RSpec.describe Door do 
    it "test_Instantiates_a_Door_with_valid_attributes" do 
            expect(door.class).to be Door
            expect(door.door_ID).to eq 1
    end
end



#------------------------------------Scenario 1--------------------------------------------------------

RSpec.describe TestProcess do
        column2.column_elevatorList[0].elevator_currentFloor = 2
        column2.column_elevatorList[0].elevator_status = 'idle'
        column2.column_elevatorList[1].elevator_currentFloor = 6
        column2.column_elevatorList[1].elevator_status = 'idle'
end
scenario1 = TestProcess.new(column2, 3, 'up', 7)    
    

RSpec.context "scenario-1-select_elevator" do
    it "test_Part_1_of_scenario_1_chooses_the_best_elevator" do
        expect(scenario1.selectedElevator.elevator_ID).to be 1
    end
    it "test_Part_1_of_scenario_1_picks_up_the_user" do
        expect(scenario1.pickedUpUser).to be TRUE
    end
    it "test_Part_1_of_scenario_1_brings_the_user_to_destination" do
        expect(scenario1.selectedElevator.elevator_currentFloor).to be 7
    end
    it "test_Part_1_of_scenario_1_ends_with_all_the_elevators_at_the_right_position" do
        expect(column2.column_elevatorList[0].elevator_currentFloor).to be 7
        expect(column2.column_elevatorList[1].elevator_currentFloor).to be 6
    end
end
 
#------------------------------------Scenario 2--------------------------------------------------------
# puts "Scenario 2: ElevatorID, currentFloor"
column3.column_elevatorList[0].elevator_currentFloor = 10
column3.column_elevatorList[0].elevator_status = 'idle'
column3.column_elevatorList[1].elevator_currentFloor = 3
column3.column_elevatorList[1].elevator_status = 'idle'
# puts column1.requestElevator(1, 'up').elevator_ID
scenario21 = TestProcess.new(column3, 1, 'up', 6)    

RSpec.describe Elevator do
    it "test_Part_1_of_scenario_1_chooses_the_best_elevator" do
        expect(scenario21.selectedElevator.elevator_ID).to be 2
    end
    it "test_Part_1_of_scenario_1_picks_up_the_user" do
        expect(scenario21.pickedUpUser).to be TRUE
    end
    
    it "test_Part_1_of_scenario_1_brings_the_user_to_destination" do
        expect(column3.requestElevator(1, 'up').requestFloor(6).elevator_currentFloor).to be 6
    end
    
end
scenario22 = TestProcess.new(column3, 3, 'up', 5)
RSpec.describe Elevator do
    it "test_Part_1_of_scenario_1_chooses_the_best_elevator" do
        expect(scenario22.selectedElevator.elevator_ID).to be 2
    end
    it "test_Part_1_of_scenario_1_picks_up_the_user" do
        expect(scenario22.pickedUpUser).to be TRUE
    end
    
    it "test_Part_1_of_scenario_1_brings_the_user_to_destination" do
        expect(column3.requestElevator(13, 'up').requestFloor(5).elevator_currentFloor).to be 5
    end
end
scenario23 = TestProcess.new(column3, 9, 'down', 2)
RSpec.describe Elevator do
    it "test_Part_1_of_scenario_1_chooses_the_best_elevator" do
        expect(scenario23.selectedElevator.elevator_ID).to be 1
    end
    it "test_Part_1_of_scenario_1_picks_up_the_user" do
        expect(scenario23.pickedUpUser).to be TRUE
    end
    
    it "test_Part_1_of_scenario_1_brings_the_user_to_destination" do
        expect(scenario23.selectedElevator.elevator_currentFloor).to be 5
    end

    it "test_Part_1_of_scenario_1_ends_with_all_the_elevators_at_the_right_position" do
        expect(column3.column_elevatorList[0].elevator_currentFloor).to be 5
        
    end
    it "test_Part_1_of_scenario_1_ends_with_all_the_elevators_at_the_right_position" do
        expect(column3.column_elevatorList[1].elevator_currentFloor).to be 5
    end
end


# #------------------------------------Scenario 3--------------------------------------------------------
# puts "Scenario 3: ElevatorID, currentFloor"
column4.column_elevatorList[0].elevator_currentFloor = 10
column4.column_elevatorList[0].elevator_status = 'idle'
column4.column_elevatorList[1].elevator_currentFloor = 3
column4.column_elevatorList[1].elevator_status = 'moving'
column4.column_elevatorList[1].elevator_direction = 'up'

# # puts column1.requestElevator(1, 'up').elevator_ID
column4.requestElevator(3, 'down').requestFloor(2)
column4.column_elevatorList[1].elevator_currentFloor = 6
column4.column_elevatorList[1].elevator_status = 'idle'

column4.requestElevator(10, 'down').requestFloor(3)
column4.requestElevator(9, 'down').requestFloor(2)


RSpec.context "scenario-3-select_elevator" do
    # it "test_Part_1_of_scenario_1_chooses_the_best_elevator" do
    #     expect(scenario3.selectedElevator.elevator_ID).to be 1
    # end
    # it "test_Part_1_of_scenario_1_picks_up_the_user" do
    #     expect(scenario3.pickedUpUser).to be TRUE
    # end
    # it "test_Part_1_of_scenario_1_brings_the_user_to_destination" do
    #     expect(scenario3.selectedElevator.elevator_currentFloor).to be 7
    # end
    # it "test_Part_1_of_scenario_1_ends_with_all_the_elevators_at_the_right_position" do
    #     expect(column4.column_elevatorList[0].elevator_currentFloor).to be 7
    #     expect(column4.column_elevatorList[1].elevator_currentFloor).to be 6
    # end
end
RSpec.context "scenario-3-select_elevator" do
    # it "test_Part_1_of_scenario_1_chooses_the_best_elevator" do
    #     expect(scenario3.selectedElevator.elevator_ID).to be 1
    # end
    # it "test_Part_1_of_scenario_1_picks_up_the_user" do
    #     expect(scenario3.pickedUpUser).to be TRUE
    # end
    # it "test_Part_1_of_scenario_1_brings_the_user_to_destination" do
    #     expect(scenario3.selectedElevator.elevator_currentFloor).to be 7
    # end
    # it "test_Part_1_of_scenario_1_ends_with_all_the_elevators_at_the_right_position" do
    #     expect(column4.column_elevatorList[0].elevator_currentFloor).to be 7
    #     expect(column4.column_elevatorList[1].elevator_currentFloor).to be 6
    # end
end

