% Initializing glass limits to 700ml and 300ml
full = [700 300];

%Initializing desirable values for both glasses
d1=100;
d2=300;
dstate=0;

%Initializing state
state=[0 0; full(1) 0; 0 full(2)];

%Nodes for future check - Queue
q=[2, 3];

%Already checked nodes - Queue
checked=[1];

%Connections with descendants
descendants = [0 1 1];

%%%%%%%%%%%%%%%%%%%%%%%% BFS %%%%%%%%%%%%%%%%%%%%%%%%
while ~isempty(q)
  %Node check and dequeue
  current=q(1);
  checked=[checked q(1)];
  q(1)=[];
  
  %Check for desirabledisp(X) State
  if (state(current, 1)==d1 && state(current, 2)==d2)
    %End - Desirable State Found
    dstate=current;
    break;
   else
    %Finding descendants
   
    %%%% Empty glass_1
    if (state(current,1) ~= 0)
      new_state=[0 state(current, 2)];
      state= [state; new_state];
      descendants(q(1), size(state,1))=1;
    
      %New node enqueue
      exist=find(checked==size(state,1));
      if isempty(exist)
        q=[q size(state,1)];
      end
    end
    
    %%%% Empty glass_2
    if (state(current,2) ~= 0)    
      new_state=[state(current, 1) 0];
      state= [state; new_state];
      descendants(current, size(state,1))=1;
    
      %New node enqueue
      exist=find(checked==size(state,1));
      if isempty(exist)
        q=[q size(state,1)];
      end
    end 
    
    %%%% Pour from glass_1 to glass_2
    if (state(current,1) ~= 0)
      if (state(current, 2) ~= full(2))
        if (state(current,1)>= (full(2) - state(current, 2)))
          g1=state(current,1)-(full(2) - state(current, 2));
          g2=full(2);
       else
         g1=0;
         g2=state(current, 2)+state(current, 1);
        end
        new_state=[g1 g2];
        
        %Check if new_state is identcal with current's parent state
        for  i= 1:size(descendants, 2)
          if descendants(i, current)==1
            row=i;
            break;
           end
        end
        if ~(state(row, 1)==g1 && state(row, 2)==g2)     
          state= [state; new_state];
          descendants(current, size(state,1))=1;
      
          %New node enqueue
          exist=find(checked==size(state,1));
          if isempty(exist)
            q=[q size(state,1)];
          end
        end        
     end
    end
    
    %%%% Pour from glass_2 to glass_1
    if (state(current,2) ~= 0)
      if (state(current, 1) ~= full(1))
        if (state(current,2)>= (full(1) - state(current, 1)))
          g2=state(current,2)-(full(1) - state(current, 1));
          g1=full(1);
       else
         g2=0;
         g1=state(current, 1)+state(current, 2);
        end
        new_state=[g1 g2];
        
        %Check if new_state is identcal with current's parent state
        for  i= 1:size(descendants, 2)
          if descendants(i, current)==1
            row=i;
            break;
           end
        end
        if ~(state(row, 1)==g1 && state(row, 2)==g2)     
          state= [state; new_state];
          descendants(current, size(state,1))=1;
      
          %New node enqueue
          exist=find(checked==size(state,1));
          if isempty(exist)
            q=[q size(state,1)];
          end
        end        
     end
    end
    
   end
end

if dstate==0
  X = sprintf('Combination not Possible');
  disp(X)
else
  %Last rows of descendants filled with zeroes
  rows = size(descendants, 2) - size(descendants, 1);

  for i= 1:size(descendants, 2)
      row(i)=0;
  end

  for i= 1:rows
      descendants=[descendants; row];
  end

  %Graph creation
  graph = biograph(descendants);
  view(graph);

  %Print the desirable state
  Y = sprintf('Desirable State = %d',dstate);
  disp(Y)
  Z = sprintf('Glass 1 = %d ml, Glass 2 = %d ml',state(dstate, 1), state(dstate, 2));
  disp(Z)
  bl = sprintf(' ');
  disp(bl)
  
  %Find and display parent nodes
  prev=dstate;  
  while (prev~=1)
      for  i= 1:size(descendants, 2)
          if descendants(i, dstate)==1
              prev=i;
              break;
          end
      end
      
      %Print the desirable state
      Y = sprintf('Parent State = %d',prev);
      disp(Y)
      Z = sprintf('Glass 1 = %d ml, Glass 2 = %d ml',state(prev, 1), state(prev, 2));
      disp(Z)
      bl = sprintf(' ');
      disp(bl)
      
      dstate=prev;
  end
end