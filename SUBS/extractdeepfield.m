
function [OUT]=extractdeepfield(IN,fieldnameToAccess)
	field = textscan(fieldnameToAccess,'%s','Delimiter','.');
	fieldSize=size(field{1},1);
	
    
    try % TEMP TODO
    switch fieldSize
		case 1
			OUT=extractfield(IN,fieldnameToAccess);
		case 2
			OUT=extractfield(cell2mat(extractfield(IN,field{1}{1})),field{1}{2} );
		case 3
			OUT=extractfield(cell2mat(extractfield(cell2mat(extractfield(IN,field{1}{1})),field{1}{2} )),field{1}{3});
		case 4
			OUT=extractfield(cell2mat(extractfield(cell2mat(extractfield( cell2mat(extractfield(IN,field{1}{1})),field{1}{2} )),field{1}{3})),field{1}{4});
    end
    catch
        save
        dfgesfgsdg
    end
    
    
end
