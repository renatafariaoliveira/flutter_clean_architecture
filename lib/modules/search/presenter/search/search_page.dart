import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/modules/search/domain/entities/result_search.dart';
import 'package:flutter_clean_architecture/modules/search/domain/errors/errors.dart';
import 'package:flutter_clean_architecture/modules/search/presenter/search/search_bloc.dart';
import 'package:flutter_clean_architecture/modules/search/presenter/search/states/states.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ModularState<SearchPage, SearchBloc> {
  FocusNode _inputSearchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _inputSearchFocus = FocusNode();
  }

  @override
  void dispose() {
    _inputSearchFocus.dispose();
    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_inputSearchFocus);
    });
  }

  Widget _buildList(List<ResultSearch> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, index) {
        var _item = list[index];
        return Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 24.0, left: 24.0),
          child: ListTile(
            tileColor: Colors.grey.withOpacity(0.1),
            title: Container(child: Text(_item?.title ?? '', overflow: TextOverflow.ellipsis)),
            subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _item?.type == 'User'
                          ? Icon(
                              Icons.people,
                              size: 16.0,
                            )
                          : Icon(
                              Icons.house,
                              size: 16.0,
                            ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: Text(
                        _item?.content ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                )),
            leading: _item?.image == null
                ? Container()
                : CircleAvatar(
                    backgroundImage: NetworkImage(
                      _item.image,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildError(FailureSearch error) {
    if (error is InvalidTextError) {
      return Center(
        child: Text(
          'INVALID\TEXT',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.5)),
        ),
      );
    } else if (error is DatasourceError) {
      return Center(
        child: Text(
          'DATASOURCE\ERROR',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.5)),
        ),
      );
    } else {
      return Center(
        child: Text(
          'ERROR',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.5)),
        ),
      );
    }
  }

  Widget _buildInputSearch() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 12.0, right: 24.0, left: 24.0),
      child: TextField(
        onChanged: controller.add,
        focusNode: _inputSearchFocus,
        onTap: _requestFocus,
        cursorColor: Theme.of(context).primaryColor,
        style: TextStyle(color: Colors.grey),
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          labelText: 'Search',
          labelStyle: TextStyle(
            color: _inputSearchFocus.hasFocus ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Image.asset('assets/images/github-header.jpg'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).unfocus();
        });
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            _buildInputSearch(),
            Expanded(
              child: StreamBuilder<SearchState>(
                stream: controller,
                builder: (context, snapshot) {
                  final _state = controller.state;

                  if (_state is SearchStart) {
                    return Center(
                      child: Text(
                        'START\nSEARCHING',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.5)),
                      ),
                    );
                  } else if (_state is SearchFailure) {
                    return _buildError(_state.error);
                  } else if (_state is SearchLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (_state is SearchSuccess) {
                    return _buildList(_state.list);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
