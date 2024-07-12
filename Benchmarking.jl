using Ipopt
using PowerModels
using Base
using JLD2
function process_m_file(file_path::String)
    println("Processing file: ", file_path)
    run_opt(file_path)
end

# Function to process all .m files in a directory
function process_all_m_files_in_folder(folder_path::String)
    # Step 1: Get list of files in a directory
    files = readdir(folder_path)
    # Step 2: Filter .m files
    m_files = filter(x -> occursin(r"\.m$", x), files)
    
    # Step 3: Iterate over each .m file and process it
    for file in m_files
        file_path = joinpath(folder_path, file)
        process_m_file(file_path)
    end
end

function run_opt(file_path::String)
    println("Processing file:", file_path)
    sol=solve_ac_opf(file_path, Ipopt.Optimizer)
    
    filename = separate_filename(file_path)
    filename = chop(filename)
    dictname= filename * "jld2"
    filename= filename * "txt"
    print(filename)
    io = open(filename, "w")
    redirect_stdout(io) do
        # Write the solution to file
        println("solve_time:    ", sol["solve_time"])  
        println("optimizer:     ", sol["optimizer"])    
        println("termination_status:    ",sol["termination_status"]) 
        println("dual_status:   ",sol["dual_status"])        
        println("primal_status:     ",sol["primal_status"])      
        println("objective:     ",sol["objective"])      
    end    
    # Close the file
    close(io) 

    # Save the dict
    save_object(dictname, sol["solution"])  

end

function separate_filename(filepath::String)
    file = basename(filepath)  # Get the filename with extension
    #dirname = dirname(filepath)    # Get the directory path
    println("File name to be generated in .txt format:", file)
    return file
end

# Benchmark:
folder_path = "/Users/hgangwar/pglib-opf/"
process_all_m_files_in_folder(folder_path)


