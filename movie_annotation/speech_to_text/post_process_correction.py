a = ['many',300,301,'perfect']
b = ['different', 301,320,'continuous']
c = ['so',302,330,'perfect']
d = ['enormous',299,310,'perfect']
A = [a,b,c,d]
def ordering_words(word_list):
    ls_of_st = []
    output_ls = []
    word_list_temp = [i for i in word_list]
    for l in word_list:
        ls_of_st.append(l[2])
    while len(output_ls) != len(word_list):
        min_index = ls_of_st.index(min(ls_of_st))
        output_ls.append(word_list_temp[min_index])
        word_list_temp.remove(word_list_temp[min_index])
        ls_of_st.remove(ls_of_st[min_index])
    return output_ls


